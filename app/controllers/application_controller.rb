class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_action :route
  # skip_before_filter :route

  def after_sign_in_path_for(resource)
    if resource.admin? == true
      '/admin/admins/dashboard'
    elsif resource.parent? == true
      '/parent/parents/dashboard'
    elsif resource.mosque? == true
      '/mosque/mosques/dashboard'
    end
  end

  def route
    unless user_signed_in?
      redirect_to '/users/sign_in'
    end
  end

end
