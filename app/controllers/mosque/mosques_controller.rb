class Mosque::MosquesController < ApplicationController
  before_action :route

  def index

  end

  def dashboard

  end

  def route
    if user_signed_in?
      redirect_to '/admin/admins' and return if current_user.admin? == true
      redirect_to '/parent/parents' and return if current_user.parent? == true
      # redirect_to '/mosque/mosques' and return if current_user.mosque? == true
    else
      redirect_to '/users/sign_in'
    end
  end
end
