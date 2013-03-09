module UserHelper
  def sign_in(user)
    post sessions_path, email: user.email, password: user.password
    #User.authenticate(user.email, user.password)
  end
end
