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


    private

    def event_params
        params.require(:event).permit(:name, :host_user, :price, :description, :start_time, :finish_time, :timezone, :venue, :venueData, :eventbrite_id)
    end

end
