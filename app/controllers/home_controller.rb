class HomeController < ApplicationController
  layout 'home'

  def index
    redirect_to bank_dashboards_path if user_signed_in?
  end
end
