module Bank
  class BaseController < ApplicationController
    before_action :authenticate_user!

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: %i[name])
    end
  end
end
