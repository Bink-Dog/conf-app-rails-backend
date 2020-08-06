require 'net/http'
require 'json'

class EventsController < ApplicationController

    def index
        events = Event.all
        render json: events
    end


    def show
        event = Event.find(params[:id])
        render json: event
    end



    def create
        event = Event.new(event_params)
        if event.save
            render json: event
        else
            render json: { errors: event.errors.full_messages }
        end
    end


    def update
        event = Event.find(params[:id])
        event.update(event_params)
        if event.save
            render json: event
        else
            render json: { errors: event.errors.full_messages }
        end
    end


    def destroy
        event = Event.find(params[:id])
        event.destroy
    end

    def home_screen_data
        future = Event.joins(:user_events).where("user_id = ? and finish_time >= ?", current_user.id, Time.now)

        eventIds = EbAttendee.where("email = ? and used = false", current_user.email).map do |att|
            att.event_id
        end

        available = Event.where("eventbrite_id in (?) and finish_time >= ?", eventIds, Time.now)

        # registered = UserEvent.where("user_id = ?", current_user.id)
        render json: {
                future: future,
                available: available
        }
    end

    def eventbright_register
        event = Event.find(params[:id])
        registered = false
        user_event = nil
        myuser = current_user

        EbAttendee.where("used = false and event_id = ? and email = ?", event.eventbrite_id, myuser.email).each do |att|
            if !registered
                att.update(used: true)
                user_event = UserEvent.create(user_id: myuser.id, event_id: event.id)
                registered = true
            end
        end

        render json: user_event
    end


    def get_future_events
        events = Event.where("finish_time >= ? AND host_user = ?", Time.now, session[:user_id]).limit(5).order(:finish_time)
        render json: events
    end


    def get_past_events
        events = Event.where("finish_time < ? AND host_user = ?", Time.now, session[:user_id]).limit(5).order("finish_time DESC")
        render json: events
    end

    def process_webhook
        config = params[:config]
        api_url = params[:api_url]
        webhook_id = config[:webhook_id]
        action = config[:action]
        event = Event.where("eventbrite_webhook_id = ?", webhook_id).limit(1).first!
        user = User.find(event.host_user)
        token = user.eventbrite_token

        puts "------- webhook_id #{webhook_id} --------"
        puts "------- api_url #{api_url} --------"
        puts "------- token #{token} --------"
        puts "------- action #{action} --------"

        url = URI.parse(api_url)
        bearer_header_value = 'Bearer ' + token
        req = Net::HTTP::Get.new(url.to_s, {'Authorization'=>bearer_header_value})
        res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
            http.request(req)
        }

        puts res.body

        json = JSON.parse(res.body)
        if action == "attendee.updated"
            insert_attendee(json)
        elsif action == "event.updated"
            update_event(json)
        end
    end



    private

    def update_event(json)
        id = json["id"]
        name = json["name"]["text"]
        description = json["description"]["text"]
        startStr = json["start"]["local"]
        endStr = json["end"]["local"]
        timezone = json["start"]["timezone"]

        puts "--- id #{id} ---"
        puts "--- name #{name} ---"

        eb_event = Event.find_by(eventbrite_id: id)

        if eb_event.start_time > DateTime.now
            eb_event.update(
                    name: name,
                    description: description,
                    start_time: startStr,
                    finish_time: endStr,
                    timezone: timezone
            )
        else
            eb_event.update(
                    name: name,
                    description: description
            )
        end
    end

    def insert_attendee(json)
        eb_event_id = json["event_id"]
        email = json["profile"]["email"]
        id = json["id"]

        puts "----- att: #{email}/#{id} ----"

        dbrec = EbAttendee.find_by("event_id = ? and user_eventbrite_id = ?", eb_event_id, id)

        if dbrec == nil
            EbAttendee.create(event_id: eb_event_id, email: email, used: false, user_eventbrite_id: id)
        else
            unless dbrec.used
                dbrec.update(event_id: eb_event_id, email: email)
            end
        end
    end

    def event_params
        params.require(:event).permit(:name, :host_user, :price, :description, :start_time, :finish_time, :timezone, :venue, :venueData, :eventbrite_id, :eventbrite_webhook_id)
    end

end
