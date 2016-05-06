class Users::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]
  layout "application"

# GET /resource/sign_up
  def new
    @role = "parent"
    super
  end

# POST /resource
  def create
    build_resource(sign_up_params)
    if resource.valid?
      if params[:role] == 'parent'
        resource.role_id = Role.where(:name => 'parent').first.id
        if resource.save!
          FamilyCode.create(:code => SecureRandom.hex(4), :user_id => resource.id)
        end
      else
        resource.role_id = Role.where(:name => 'mosque').first.id
        resource.save!
      end
    end
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      # set_minimum_password_length
      respond_with resource
    end
  end

  def new_sign_up
    @role = "mosque"
    build_resource({})
    yield resource if block_given?
    respond_with self.resource
  end

# GET /resource/edit
# def edit
#   super
# end

# PUT /resource
# def update
#   super
# end

# DELETE /resource
# def destroy
#   super
# end

# GET /resource/cancel
# Forces the session data which is usually expired after sign
# in to be expired now. This is useful if the user wants to
# cancel oauth signing in/up in the middle of the process,
# removing all OAuth session data.
# def cancel
#   super
# end
  private
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :phone, :about_me, :email, :password, :password_confirmation)
  end
# protected

# If you have extra params to permit, append them to the sanitizer.
# def configure_sign_up_params
#   devise_parameter_sanitizer.for(:sign_up) << :attribute
# end

# If you have extra params to permit, append them to the sanitizer.
# def configure_account_update_params
#   devise_parameter_sanitizer.for(:account_update) << :attribute
# end

# The path used after sign up.
# def after_sign_up_path_for(resource)
#   super(resource)
# end

# The path used after sign up for inactive accounts.
# def after_inactive_sign_up_path_for(resource)
#   super(resource)
# end
end
