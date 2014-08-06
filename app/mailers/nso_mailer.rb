class NsoMailer < ActionMailer::Base
  default from: 'donotreply@abtech.edu'

	def registration_email(registration)
		@registration = registration #makes the @registration available to mailer view
    mail(to: registration.email, subject: 'AB-Tech New Student Orientation') do |format|
  		format.html { render 'registrations/scheduling_text.html.erb' }
  	end
  end

	def online_registration_email(registration)
		@registration = registration #makes the @registration available to mailer view
    mail(to: registration.email, subject: 'AB-Tech Online New Student Orientation') do |format|
  		format.html { render 'registrations/online_scheduling_text.html.erb' }
		end
  end

	def registration_cancellation_email(registration)
		@registration = registration
		mail :to => registration.email, :subject => "New Student Orientation Cancellation" do |format|
  		format.html { render 'registrations/registration_cancellation_email.html.erb' }
		end
	end

	def after_cancellation_email(registration)
		@registration = registration
		mail :to => registration.email, :subject => "New Student Orientation Cancellation" do |format|
  		format.html { render 'registrations/after_cancellation_text.html.erb' }
		end
	end

	def send_reminder_emails(registration)
		@registration = registration
		mail :to => registration.email, :subject => "Reminder: New Student Orientation" do |format|
	  	format.html { render 'registrations/reminder_email.html.erb' }
		end
	end
end
