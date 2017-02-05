class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    callback_from(:facebook)
  end

  def passthru
    super
  end

  def failure
    redirect_to root_path
  end

  protected

  def after_omniauth_failure_path_for(scope)
    super(scope)
  end

  private

  def callback_from(provider)
    provider = provider.to_s
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to root_path
    end
  end
end
