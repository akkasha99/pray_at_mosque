class Admin::AdminsController < ApplicationController
  before_action :route
  layout "application"

  def index

  end

  def dashboard
    @parents = User.joins(:role).where("roles.name=?", "parent")
    @children = User.joins(:role).where("roles.name=?", "child")
    @mosques = User.joins(:role).where("roles.name=?", "mosque")
  end

  def route
    if user_signed_in?
      # redirect_to '/admin/admins' and return if current_user.admin? == true
      redirect_to '/parent/parents/dashboard' and return if current_user.parent? == true
      redirect_to '/mosque/mosques/dashboard' and return if current_user.mosque? == true
    else
      redirect_to '/users/sign_in'
    end
  end
end
