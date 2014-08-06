class CancelRegistrationController < ApplicationController
  def new
  end

	def edit
		@registration = Registration.find_by_registration_cancellation_token!(params[:id])
	end

	def create
  	registration = Registration.find_all_by_email(params[:email]).last
  	if registration
			registration.send_cancellation_email
  		redirect_to root_url, :notice => "Email sent with cancellation instructions."
		end
	end
end
