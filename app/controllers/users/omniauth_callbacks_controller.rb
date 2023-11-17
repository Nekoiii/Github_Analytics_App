class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.from_omniauth(request.env['omniauth.auth'])
    unless @user.persisted?
      user_not_persisted(request)
      return
    end

    user_persisted
  end

  def user_persisted
    jwt = Warden::JWTAuth::UserEncoder.new.call(@user, :user, nil)
    redirect_to "#{ENV['FRONT_APP_URL']}?token=#{jwt[0]}&userName=#{@user.github_login}", allow_other_host: true
  end

  def user_not_persisted(request)
    session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
    redirect_to ENV['FRONT_APP_URL']
  end

  def failure
    reset_session

    redirect_to ENV['FRONT_APP_URL']
  end
end
