class ApplicationController < ActionController::Base
  # before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found
    flash[:alert] = I18n.t('errors.response.not_found')
    redirect_to({ action: :index })
  end
end
