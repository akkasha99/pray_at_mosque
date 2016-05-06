class Users::SessionsController < Devise::SessionsController
  layout "application"
# before_filter :configure_sign_in_params, only: [:create]

# GET /resource/sign_in
  def new
    @role = "parent"
    super
  end

# POST /resource/sign_in
# def create
#   super
# end

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
