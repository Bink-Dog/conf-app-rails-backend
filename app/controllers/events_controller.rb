require 'net/http'
require 'json'
require 'mux_ruby'

class EventsController < ApplicationController

    MuxRuby.configure do |config|
        config.username = ENV['MUX_TOKEN_ID']
        config.password = ENV['MUX_TOKEN_SECRET']
    end

    def index
        events = Event.all
        render json: events
    end

    def show
        event = Event.find(params[:id])
        render json: event
    end

    def create
        venue_data = create_admin_static_venue_data(event_params["venue"])

        event = Event.new(event_params)
        event.admin_venue_data = venue_data[:admin].to_json
        event.static_venue_data = venue_data[:static].to_json

        if event.save
            render json: event
        else
            render json: {errors: event.errors.full_messages}
        end
    end

    def update
        event_id = params[:id]
        event = Event.find(event_id)
        event.update(event_params)
        puts("notify users")
        notify_event_users(event_id)
        if event.save
            render json: event
        else
            render json: {errors: event.errors.full_messages}
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

    def event_admin_venue_data
        event = Event.find(params[:id])
        if event.host_user == session[:user_id]
            render json: {
                    admin_venue_data: event.admin_venue_data
            }
        elsif
        render json: {
                errors: "You don't have access to this event data"
        }
        end
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
        req = Net::HTTP::Get.new(url.to_s, {'Authorization' => bearer_header_value})
        res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') { |http|
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

    def event_management_info
        headerSecret = request.headers['HTTP_MAIN_SERVER_SECRET']

        if headerSecret != ENV['MAIN_SERVER_SECRET']
            render json: {
                    message: "Secrets don't match"
            }, status: 403
        else
            event_id = params[:id]
            event = Event.find(event_id.to_i)

            render json: {
                    max_users: event.max_attendees
            }
        end
    end

    def event_user_info
        event_id = params[:id]
        event = Event.find(event_id.to_i)
        user_event = UserEvent.find_by(user_id: current_user_id, event_id: event_id)
        render json: {
                is_host: event.host_user == current_user_id,
                my_role: user_event.role
        }
    end

    def webhook_echo
        if params["type"].start_with?("video.live_stream")
            lsId = params["object"]["id"]
            streamStatus = params["data"]["status"]
            data = params["data"].to_json
            dbrec = Livestream.find_by(mux_id: lsId)

            if dbrec == nil
                Livestream.create(mux_id: lsId, last_update: DateTime.current, data: data)
            else
                dbrec.update(last_update: DateTime.current, data: data)
            end
        end
    end

    private

    def create_admin_static_venue_data(venue)

        venue_data = {}
        static = {}
        venue_data[:static] = static
        admin = {}
        venue_data[:admin] = admin

        venue_data[:main_stream] = create_mux_stream(:main_stream, static, admin)

        if venue == "MainVenue"
            venue_data[:room_stream_1] = create_mux_stream(:room_stream_1, static, admin)
            venue_data[:room_stream_2] = create_mux_stream(:room_stream_2, static, admin)
            venue_data[:room_stream_3] = create_mux_stream(:room_stream_3, static, admin)
            venue_data[:room_stream_4] = create_mux_stream(:room_stream_4, static, admin)
        end

        venue_data
    end

    def create_mux_stream(label, static, admin)
        # API Client Init
        live_api = MuxRuby::LiveStreamsApi.new

        # Create the Live Stream
        create_asset_request = MuxRuby::CreateAssetRequest.new
        create_asset_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]
        create_live_stream_request = MuxRuby::CreateLiveStreamRequest.new
        create_live_stream_request.new_asset_settings = create_asset_request
        create_live_stream_request.playback_policy = [MuxRuby::PlaybackPolicy::PUBLIC]

        static_label = {}
        static[label] = static_label
        admin_label = {}
        admin[label] = admin_label

        begin
            #Create a live stream playback ID
            stream = live_api.create_live_stream(create_live_stream_request)

            id = stream.data.id
            stream_key = stream.data.stream_key
            playback_id = stream.data.playback_ids[0].id

            # Give back the RTMP entry point playback endpoint
            puts "New Live Stream created!"
            puts "RTMP Endpoint: rtmp://live.mux.com/app"
            puts "Stream Key: #{stream.data.stream_key}"

            static_label[:id] = id
            admin_label[:id] = id
            static_label[:playback_id] = playback_id
            admin_label[:playback_id] = playback_id
            admin_label[:stream_key] = stream_key
        rescue MuxRuby::ApiError => e
            puts "Exception when calling LiveStreamsApi->create_live_stream_playback_id: #{e}"
        end
    end

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

    def notify_event_users(event_id)

        url = "#{ENV['WS_SERVER']}/user/updateData/#{event_id}"
        puts(url)
        uri = URI(url)
        https = Net::HTTP.new(uri.host, uri.port)
        if url.start_with?("https")
            https.use_ssl = true
        end

        request = Net::HTTP::Post.new(uri.path)

        request['Content-Type'] = 'application/json'
        # request['HEADER2'] = 'VALUE2'
        #
        request.body = "{}"

        response = https.request(request)
        puts response.body

        # uri = URI.parse("http://localhost:3000/users")
        # header = {'Content-Type': 'text/json'}
        #
        # req = Net::HTTP::Get.new(url.to_s, {'Authorization'=>bearer_header_value})
        # res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
        #   http.request(req)
        # }
        #
        # puts res.body

    end

    def notify_livestream_update(mux_id)

        url = "#{ENV['WS_SERVER']}/user/updateMuxStream/#{mux_id}"
        puts(url)
        uri = URI(url)
        https = Net::HTTP.new(uri.host, uri.port)
        if url.start_with?("https")
            https.use_ssl = true
        end

        request = Net::HTTP::Post.new(uri.path)

        request['Content-Type'] = 'application/json'
        request.body = "{}"

        response = https.request(request)
        puts response.body

    end
end
