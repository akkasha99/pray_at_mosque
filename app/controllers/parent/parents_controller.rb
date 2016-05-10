class Parent::ParentsController < ApplicationController
  before_action :route, :except => [:check_email]
  layout 'application'

  def index
    @verse_of_day = DisplayingContent.where("content_type=?", 'verse').order('created_at').first
    @hadith_of_day = DisplayingContent.where("content_type=?", 'hadith').order('created_at').first
    @quote_of_day = DisplayingContent.where("content_type=?", 'quote').order('created_at').first
  end

  def family
    @children = current_user.children.where(:is_deleted => false, :is_active => true)
  end

  def profile
    @user = current_user
  end

  def update_profile
    @user = current_user
    @user.update(parent_update_params)
    render :text => "success"
  end

  def create
    not_existing_user = User.where(:email => params[:user][:email]).empty?
    if not_existing_user
      random_password = SecureRandom.hex(4)
      child = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :phone => params[:user][:phone], :password => random_password, :parent_id => current_user.id)
      if child.save!
        render :text => "success"
      else
        render :text => "error"
      end
    else
      render :text => "error2"
    end
  end

  def check_email
    unless params[:user][:email].blank?
      @user = User.where(:email => params[:user][:email]).first
      render :text => "true" if @user.blank?
      render :text => "false" if @user.present?
    else
      render :text => "true"
    end
  end

  def route
    if user_signed_in?
      redirect_to '/admin/admins/dashboard' and return if current_user.admin? == true
      redirect_to '/mosque/mosques' and return if current_user.mosque? == true
    else
      redirect_to '/users/sign_in'
    end
  end

  private

  def parent_update_params
    params.require(:user).permit(:first_name, :last_name, :phone, :about_me, :avatar)
  end

end
