class HomeController < ApplicationController
  layout 'home'

  def index
    redirect_to bank_dashboards_url if user_signed_in?
  end
end
