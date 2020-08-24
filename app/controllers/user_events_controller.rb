class UserEventsController < ApplicationController

    def index
        user_event = UserEvent.all 
        render json: user_event
    end

    def show_users
        search_string = params[:search_string]

        if search_string == ""
            user_event = UserEvent.where("event_id = ?",  params[:id]).limit(50)
        else 
            user_event = UserEvent.joins(:user).where("event_id = ? AND (users.name ILIKE ? OR users.email ILIKE ?)",  params[:id], '%' + search_string + '%', '%' + search_string + '%').limit(50)
        end

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