class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found
    flash[:alert] = I18n.t('errors.response.not_found')
    redirect_to({ action: :index })
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
  end

end
