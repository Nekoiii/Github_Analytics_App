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
    redirect_to "http://localhost:3000/?token=#{jwt[0]}&userName=#{@user.github_login}"
  end

  def user_not_persisted(request)
    session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
    redirect_to 'http://localhost:3000/'
  end

  def failure
    reset_session

    redirect_to 'http://localhost:3000/'
  end
end
