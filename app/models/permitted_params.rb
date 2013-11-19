class PermittedParams < Struct.new(:params)
	def user
		params.require(:user).permit(:email, :name, :username, :password, :password_confirmation)
	end

	def user_attributes
		[:email, :name, :username, :password]
	end

	def pre_subscription
		params.require(:pre_subscription).permit(:email, :name)
	end

	def pre_subscriptions_attributes
		[:email, :name, :hub]
	end
end
