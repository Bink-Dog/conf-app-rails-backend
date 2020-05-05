class UsersController < ApplicationController

    def index
        users = User.all 
        render json: users
    end

    def new
        user  = User.new
    end

    def create
        user = User.find_or_create_by(email: user_params[:email])
    end


    def update
        user = User.find(user_params[:id])
        user.update(user_params)
        if user.save
            render json: user
        else
            render json: { errors: user.errors.full_messages }
        end
    end

    def destroy
        user = User.find(params[:id])
        user.destroy
    end

    private

    def user_params
        params.permit(:email)
    end

end

