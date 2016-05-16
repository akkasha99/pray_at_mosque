class Parent::ParentsController < ApplicationController
  before_action :route, :except => [:check_email]
  layout 'application'
  include ApplicationHelper

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
    if params[:profile] == "true"
      render :text => "success"
    else
      render :partial => 'profile_image'
    end
  end

  def update_password
    @user = current_user
    if @user.valid_password?(params[:Old_Password])
      if @user.update_attributes(:password => params[:user][:password])
        sign_in @user, :bypass => true
        render :text => "success"
      else
        render :text => "error"
      end
    else
      render :text => "not"
    end
  end

  def create
    unless params[:user][:email].blank? && params[:user][:phone].blank?
      not_existing_user = User.where(:email => params[:user][:email]).empty?
      if not_existing_user
        random_password = SecureRandom.hex(4)
        child = User.new(:first_name => params[:user][:first_name], :last_name => params[:user][:last_name], :email => params[:user][:email], :phone => params[:user][:phone], :password => random_password, :parent_id => current_user.id)
        if child.save!
          @children = current_user.children.where(:is_deleted => false, :is_active => true)
          render :partial => "family_list"
        else
          render :text => "error"
        end
      else
        render :text => "error2"
      end
    else
      render :text => "error3"
    end
  end

  def payment_info
    # user = current_user
    # params[:payment_information][:expiry_date] = DateTime.parse(params[:payment_information][:expiry_date]).strftime('%m/%Y')
    # payment = PaymentInformation.new(payment_method_params)
    # if payment.valid?
    #   result = create_payment_information(user, payment_method_params)
    #   if result.success?
    #     PaymentInformation.create(:user_id => user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
    #     render :text => "success"
    #   else
    #
    #   end
    # else
    #   payment.errors.full_messages.each do |msg|
    #     @error_string += msg
    #   end
    #   render :text => "false"
    # end
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

  def payment_method_params
    params.require(:payment_information).permit(:first_name, :last_name, :cvv, :card_number, :expiry_date, :user_id, :address, :city, :state, :country)
  end

end
