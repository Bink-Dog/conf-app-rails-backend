class UserEventsController < ApplicationController

    def index
        user_event = UserEvent.all 
        render json: user_event
    end

    def create
        user_event = UserEvent.create(user_id: params[:user_id], event_id: params[:event_id])
        render json: user_event
    end
    
end 