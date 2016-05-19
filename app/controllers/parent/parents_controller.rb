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
    user_payment_info = @user.payment_information
    if user_payment_info.present?
      @payment_info = Braintree::CreditCard.find(user_payment_info.payment_method_token)
    else
      @payment_info = nil
    end
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
    user = current_user
    params[:payment_information][:expiry_date] = DateTime.parse(params[:payment_information][:expiry_date]).strftime('%m/%Y')
    payment = PaymentInformation.new(payment_method_params)
    if payment.valid?
      existing_payment_info = user.payment_information
      if existing_payment_info.nil?
        result = create_payment_information(user, payment_method_params)
        if result.success?
          ne_payment_information = PaymentInformation.new(:user_id => user.id, :customer_id => result.credit_card.customer_id, :payment_method_token => result.credit_card.token, :card_type => result.credit_card.card_type)
          ne_payment_information.save(:validate => false)
          render :json => {:success => "true", :message => "Saved Successfully"}
        else
          error_string = create_error_string(result.errors)
          render :json => {:success => "false", :message => error_string}
        end
      else
        result = update_payment_information(payment_method_params, existing_payment_info.payment_method_token)
        if result.success?
          render :json => {:success => "true", :message => "Saved Successfully"}
        else
          error_string = create_error_string(result.errors)
          render :json => {:success => "false", :message => error_string}
        end
      end
    else
      error_string = create_error_string(payment.errors.full_messages)
      render :json => {:success => "false", :message => error_string}
    end
  end

  def create_transaction
    user = current_user
    user_payment_information = user.payment_information
    if user_payment_information.nil?
      render :json => {:success => "false", :message => "Please Enter Credit Card Information first."}
    else
      if params[:transaction][:transaction_amount].to_f > 0
        result = parent_transaction(user, params[:transaction][:transaction_amount], user_payment_information)
        if result.success?
          user.update_attributes(:parent_balance => (user.parent_balance + params[:transaction][:transaction_amount].to_f))
          TransactionHistory.create(:user_id => user.id, :payment_information_id => user_payment_information.id, :transaction_id => result.transaction.id, :transaction_type => result.transaction.type, :status => result.transaction.status, :transaction_amount => result.transaction.amount)
          render :partial => 'profile_transaction', :locals => {:@user => user}
        else
          error_string = create_error_string(result.errors)
          render :json => {:success => "false", :message => error_string}
        end
      else
        render :json => {:success => "false", :message => "Amount must be greater than 0."}
      end
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

  def create_error_string(error_object)
    error_string = ""
    error_object.each do |error|
      error_string += error.message
    end
    return error_string
  end

  private

  def parent_update_params
    params.require(:user).permit(:first_name, :last_name, :phone, :about_me, :avatar)
  end

  def payment_method_params
    params.require(:payment_information).permit(:first_name, :last_name, :cvv, :card_holder, :card_number, :expiry_date, :user_id, :address, :city, :state, :country)
  end

end
