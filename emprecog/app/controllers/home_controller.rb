class HomeController < ApplicationController
  def index
    unless current_user
      redirect_to login_path
    end
  end
end
