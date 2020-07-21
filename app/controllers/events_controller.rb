class EventsController < ApplicationController

    def index
        puts "-------------EventsController #{session[:user_id]}------------------- "
        events = Event.all 
        render json: events
    end


    def show
        puts "-------------EventsController show #{session[:user_id]}------------------- "
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


    private

    def event_params
        params.require(:event).permit(:name, :host_user, :price, :description, :start_time, :finish_time, :timezone)
    end

end
