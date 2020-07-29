require 'mini_magick'

class UsersController < ApplicationController

    def index
        users = User.all
        render json: users
    end


    def show
        user = User.find(params[:id])
        render json: user
    end


    def start
        if user = User.find_by(uid: params[:uid])
            session[:user_id] = user.id
            render json: {user: user, new_user: false, events: user.events}
        else
            user = User.new(
                    email: params[:email],
                    name: params[:name],
                    uid: params[:uid],
                    auth_provider: params[:auth_provider],
                    auth_token: params[:auth_token],
                    twitter_handle: params[:twitter_handle],
                    github_username: params[:github_username],
                    company: params[:company],
                    bio: params[:bio],
                    image_url: params[:image_url]
            )
            if user.save
                session[:user_id] = user.id
                render json: {user: user, new_user: true, events: user.events}
            else
                render json: {errors: user.errors.full_messages}
            end
        end

    end


    def logout
        session[:user_id] = nil
    end


    def update
        puts "-----env: #{Rails.env}---------------------"
        puts "-----PARAMS ID: #{params[:id]}---------------------"
        puts "-----SESSION USER ID: #{session[:user_id]}---------------------"

        user = User.find(params[:id])


        # if user.id == current_user.id
        #     puts "-----------ID MATCHED---------------"
        # end

        user.update(user_params)
        if user.save
            render json: user
        else
            render json: {errors: user.errors.full_messages}
        end
    end


    def destroy
        user = User.find(params[:id])
        user.destroy
    end


    def get_user_image
        user = User.find_by(id: params[:id])

        image = MiniMagick::Image.open(user.image_url)

        image.resize "50x50"

        send_data image.to_blob, :type => "image/jpeg", :disposition => "inline"
    end

    private

    def user_params
        params.require(:user).permit(:email, :name, :uid, :auth_provider, :auth_token, :twitter_handle, :github_username, :company, :bio, :image_url)
    end

end