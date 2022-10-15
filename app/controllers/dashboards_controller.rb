class DashboardsController < ApplicationController
  def index
    @accounts = ::Bank::Account.owner(current_user.id)
  end
end
