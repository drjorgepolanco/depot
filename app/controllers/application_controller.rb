class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :set_i18n_locale_from_params

  protected

    def authorize
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, notice: 'Please, log in'
      end
    end

    # Sets the locale from the params, but only if there is a locale in the 
    # params; otherwise, it leaves the current locale alone.
    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end
    end

    # Provides a hash of URL options that are to be considered as present 
    # whenever they aren’t otherwise provided.
    def default_url_options
      { locale: I18n.locale }
    end
end
