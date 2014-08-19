class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to "/rooms"
    end
  end
end
