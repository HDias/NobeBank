class DashboardsController < BaseController
  def index
    @accounts = ::Bank::Account.owner(current_user.id)
  end
end
