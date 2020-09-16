class LivestreamsController < ApplicationController

    def show
        livestream = Livestream.find_by(mux_id: params[:id])
        render json: livestream
    end

end
