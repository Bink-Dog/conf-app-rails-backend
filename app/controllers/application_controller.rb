class ApplicationController < ActionController::API

    # helper_method :current_user
    # helper_method :logged_in?

    def current_user
        puts "--------------Application Controller Session User ID #{session[:user_id]} ------------------"
        User.find_by(id: session[:user_id])
    end

    # def logged_in?
    #     !current_user.nil?
    # end

end
