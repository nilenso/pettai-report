class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :prevent_http
  def prevent_http
    return unless Settings.secret_app_key.present?
    head status: :forbidden unless request.ssl? && params[:secret_app_key] == Settings.secret_app_key
  end
end
