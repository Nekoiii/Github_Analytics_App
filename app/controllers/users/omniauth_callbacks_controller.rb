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
    # Local:
    # redirect_to "http://localhost:3000/?token=#{jwt[0]}&userName=#{@user.github_login}"
    # Deploy:
    redirect_to "https://github-analytics-app-front-abb2e289cc93.herokuapp.com/?token=#{jwt[0]}&userName=#{@user.github_login}"
  end

  def user_not_persisted(request)
    session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
    # redirect_to 'http://localhost:3000/'
    redirect_to 'https://github-analytics-app-front-abb2e289cc93.herokuapp.com/'
  end

  def failure
    reset_session

    # redirect_to 'http://localhost:3000/'
    redirect_to 'https://github-analytics-app-front-abb2e289cc93.herokuapp.com/'
  end
end
