class Api::V1::SessionsController < Devise::SessionsController
	respond_to :json
	def create
		user = User.find_by(email: params[:api_v1_user][:email])
		unless user.nil?
			if user.valid_password? params[:api_v1_user][:password]
				render :json => user
				return
			end
		end
		render :json => '{"error": "invalid email and password combination"}'
	end

	def destroy
		sign_out(resource_name)
	end

	protected
	def invalid_login_attempt
		warden.custom_failure!
		render :json => {:success => false, :message => "Error with your login or password"
		}, :status => 401
	end
end