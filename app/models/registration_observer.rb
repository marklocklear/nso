class RegistrationObserver < ActiveRecord::Observer
#close registration after seats are filled
	def after_create(registration)
		if registration.orientation != nil
			@orientation = registration.orientation
			close_orientation if seats_equal_zero
		end
	end

	private
	def close_orientation
		@orientation.update_attribute :active, false
	end

	private
	def open_orientation
		@orientation.update_attribute :active, true
	end

	def seats_equal_zero
		@orientation.current_number_seats.zero?	
	end
end
