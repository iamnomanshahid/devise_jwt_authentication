class Api::V1::RegistrationsController < Devise::RegistrationsController
	protect_from_forgery with: :exception
	before_action :authenticate_user!
	respond_to :json
	def create
		user = User.new(user_params)
		if user.save
			render :json => user.as_json(:email => user.email ), :status=>201
		else
			warden.custom_failure!
			render :json => user.errors, :status=>422
		end
	end

	private
	def user_params
		if params[:api_v1_user].present?
			params.require(:api_v1_user).permit(:fullname,:email,:password,:password_confirmation)
		else
			params.permit(:fullname,:email,:password,:password_confirmation)
		end
	end
end