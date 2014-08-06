class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.find_by_email(params[:email])
		if user && user.authenticate(params[:password])
			session[:user_id] = user.id
			if params[:email] == 'helpdesk@abtech.edu'
				redirect_to all_registrations_path, notice: "Successfully logged in!"
			else
				redirect_to root_url, notice: "Successfully logged in!"
			end
		else
			flash.now.alert = "Email or password is invalid"
			render "new"
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_url, notice: "Logged out!"
	end
end
