class Parent::ParentsController < ApplicationController
  before_action :route

  def index
    @verse_of_day = DisplayingContent.where("content_type=?", 'verse').order('created_at').first
    @hadith_of_day = DisplayingContent.where("content_type=?", 'hadith').order('created_at').first
    @quote_of_day = DisplayingContent.where("content_type=?", 'quote').order('created_at').first
  end

  def family
    @children = current_user.children.where(:is_deleted => false, :is_active => true)
  end

  def profile

  end

  def route
    if user_signed_in?
      redirect_to '/admin/admins/dashboard' and return if current_user.admin? == true
      redirect_to '/mosque/mosques' and return if current_user.mosque? == true
    else
      redirect_to '/users/sign_in'
    end
  end

end
