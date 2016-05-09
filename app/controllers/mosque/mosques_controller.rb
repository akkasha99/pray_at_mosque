class Mosque::MosquesController < ApplicationController
  before_action :route

  def index

  end

  def route
    if user_signed_in?
      redirect_to '/admin/admins/dashboard' and return if current_user.admin? == true
      redirect_to '/parent/parents' and return if current_user.parent? == true
    else
      redirect_to '/users/sign_in'
    end
  end
end
