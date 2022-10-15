# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  layout 'home'

  def after_sign_in_path_for(_resource)
    bank_dashboards_path
  end
end
