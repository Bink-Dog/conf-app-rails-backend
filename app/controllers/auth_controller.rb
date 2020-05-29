class AuthController < ApplicationController

    # def start
    #     user = User.find_by(uid: params[:uid])
    #     render json: user
        # if user 
        #     render json: {user: user}
        # else
        #     render json: {errors: "Login failed, please check your username or password"}
        # end
    # end


    # def login
    #     user = User.find_by(uid: params[:uid])

    #     if user 
    #         render json: {user: user}
    #     else
    #         render json: {errors: "Login failed, please check your username or password"}
    #     end
    # end


    # def auto_login
    #     if session_user
    #         render json: session_user
    #     else
    #         render json: {errors: "That ain't no user I ever heard of!"}
    #     end
    # end
    
    # old Auth
    # def login
    #     user = User.find_by(email: params[:email])

    #     if user && user.authenticate(params[:password])
    #         token = encode_token(user.id)
    #         render json: {user: user, token: token}
    #     else
    #         render json: {errors: "Login failed, please check your username or password"}
    #     end
    # end

    # def auto_login
    #     if session_user
    #         render json: session_user
    #     else
    #         render json: {errors: "That ain't no user I ever heard of!"}
    #     end
    # end

end