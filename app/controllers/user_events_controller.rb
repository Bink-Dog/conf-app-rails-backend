class UserEventsController < ApplicationController

    def index
        user_event = UserEvent.all 
        render json: user_event
    end

    def show
        user_event = UserEvent.where("event_id = ?",  params[:id])
        render json: user_event
    end

    def create
        user_event = UserEvent.create(user_id: params[:user_id], event_id: params[:event_id])
        render json: user_event
    end

    def update
        user_event = UserEvent.find(params[:id])
        user_event.update(user_event_params)
        if user_event.save
            render json: user_event
        else
            render json: { errors: user_event.errors.full_messages}
        end
        
    end

    private
    def user_event_params
        params.require(:user_event).permit(:role)
    end

    
end 