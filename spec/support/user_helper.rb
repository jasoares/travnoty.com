module UserHelper
  def sign_in(user)
    post sessions_path, email: user.email, password: user.password
  end
end
