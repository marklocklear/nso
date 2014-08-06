class Registration < ActiveRecord::Base
	belongs_to :orientation
  attr_accessible :first_name, :last_name, :email, :program, :student_id, :phone, :orientation_id, :checked_in

	validates_presence_of :first_name
	validates_presence_of :last_name
	validates_presence_of :phone
	validates_presence_of :email
	validates_format_of :email, :with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i
	validates_numericality_of :student_id
	validates_length_of :student_id, :minimum => 7, :maximum => 7
	validates_uniqueness_of :student_id, scope: :orientation_id, message:
												": A student this this Student ID is already registered for this session."

	def online
		self.registration.orientation != nil
	end

	def send_cancellation_email
		generate_token(:registration_cancellation_token)
  	self.registration_cancelled_at = Time.zone.now
  	save!
  	NsoMailer.registration_cancellation_email(self).deliver		
	end
	
	def self.send_reminder_emails
		puts Date.today
		registrations = Registration.where(orientation_id: Orientation.where(class_date: Date.today + 1), cancelled: false)
		registrations.each do |r|
			puts r.inspect
  		NsoMailer.send_reminder_emails(r).deliver
		end
	end

	def generate_token(column)
		begin
			self[column] = SecureRandom.urlsafe_base64
		end while Registration.exists?(column => self[column])
	end

	def self.to_csv(options = {})
		CSV.generate(options) do |csv|
			csv << column_names
			all.each do |registration|
				csv << registration.attributes.values_at(*column_names)
			end
		end
	end

end
