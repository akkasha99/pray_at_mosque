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
      redirect_to '/parent/parents' and return if current_user.parent? == true
      redirect_to '/mosque/mosques' and return if current_user.mosque? == true
    else
      redirect_to '/users/sign_in'
    end
  end
end
