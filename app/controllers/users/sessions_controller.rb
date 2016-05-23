class Users::SessionsController < Devise::SessionsController
  layout "application"
# before_filter :configure_sign_in_params, only: [:create]

# GET /resource/sign_in
  def new
    @role = "parent"
    super
  end

# POST /resource/sign_in
  def create
    if request.format(request) == '*/*'
      if (params[:user_id].present? && params[:user_id] != "")
        resource = User.where(:id => params[:user_id], :is_deleted => false).first
      else
        resource = User.where(:email => params[:user][:email], :is_deleted => false).first
      end
      if resource.present?
        if resource.is_active == true
          if resource.valid_password?(params[:Old_Password])
            render :json => {:success => "true", :message => "User present."}
          else
            render :json => {:success => "false", :message => "Password is wrong."}
          end
        else
          render :json => {:success => "false", :message => "User is not active."}
        end
      else
        render :json => {:success => "false", :message => "User doesn't exist."}
      end
    else
      super
    end

    # else
    #   super
    # end
    # user = User.where(:email => params[:user][:email], :is_deleted => false).first
    # if user.present?
    #   if user.is_active == false
    #     flash[:error] = "User is not active to login."
    #     redirect_to '/users/sign_out'
    #   else
    #     super
    #   end
    # else
    #   flash[:error] = "The username or password you entered is incorrect."
    #   redirect_to '/users/sign_in'
    # end
  end

# DELETE /resource/sign_out
# def destroy
#   super
# end

  def mosque_sign_in
    @role = "mosque"
  end

  def admin_sign_in
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
