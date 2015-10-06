class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  after_filter :clear_flash

  def clear_flash
    flash[:notice]=nil
    flash[:error]=nil
  end

  def after_sign_in_path_for(resource)
    map_index_path
  end
end
