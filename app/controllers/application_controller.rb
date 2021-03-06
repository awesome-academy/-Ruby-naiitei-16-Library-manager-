class ApplicationController < ActionController::Base
  include ApplicationHelper
  include SessionsHelper
  include AdminHelper
  include BooksHelper

  before_action :set_locale
  before_action :update_allowed_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def handle_record_not_found
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  rescue_from CanCan::AccessDenied do
    redirect_to home_path, flash: {danger: t("application.action_not_allowed")}
  end

  def new_url url
    return url.remove "/admin" if current_user&.member?

    return url.gsub "/user", "/admin" if !admin_page? && current_user&.admin?

    url
  end

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer
      .permit(:sign_up){|u| u.permit User::PERMITTED_FIELDS}
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    check = I18n.available_locales.include?(locale)
    I18n.locale = check ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def load_user
    @user = User.find params[:id]
  end

  def logged_in_user
    return if user_signed_in?

    store_location
    flash[:danger] = t "require_login"
    redirect_to login_url
  end

  def redirect_member
    url = request.original_url
    redirect_url = new_url(url)
    redirect_to redirect_url unless url.eql? redirect_url
  end
end
