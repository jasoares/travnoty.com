module AccountsHelper
  def confirmed?
    @user.errors.any? or @user.confirmed?
  end
end
