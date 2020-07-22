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


    def get_future_events
        events = Event.where("start_time > '" + Time.now.to_s +"'")
        render json: events
    end


    def get_past_events
        events = Event.where("start_time <" + Time.now.to_s)
        render json: events
    end


    private

    def event_params
        params.require(:event).permit(:name, :host_user, :price, :description, :start_time, :finish_time, :timezone)
    end

end
