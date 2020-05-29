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
            render json: {user: user, new_user: false}
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
                render json: {user: user, new_user: true}
            else 
                render json: {errors: user.errors.full_messages}
            end
        end
        
    end


    # def create
    #     # byebug
    #     user = User.new(
    #         email: params[:email],
    #         name: params[:name],
    #         uid: params[:uid],
    #         auth_provider: params[:auth_provider],
    #         auth_token: params[:auth_token],
    #         twitter_handle: params[:twitter_handle],
    #         github_username: params[:github_username],
    #         company: params[:company],
    #         bio: params[:bio],
    #         image_url: params[:image_url]
    #     )
    #     if user.save
    #         render json: {user: user}
    #     else 
    #         render json: {errors: user.errors.full_messages}
    #     end
    # end


    def update
        user = User.find(params[:id])
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
        params.require(:user).permit(:email, :name, :uid, :auth_provider, :auth_token, :twitter_handle, :github_username, :company, :bio, :image_url)
    end

end