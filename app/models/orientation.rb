class Orientation < ActiveRecord::Base
	has_many :registrations
  attr_accessible :seats, :class_date, :class_time, :location

	validates_presence_of :class_date, :class_time, :location
  validates :seats, :numericality => { :greater_than_or_equal_to => 0 }

  def current_number_seats
		r = self.registrations.where(cancelled: false).count
    self.seats - r
  end

#depricated method in favor of is_not_past below
	def self.is_not_past_date(orientation)
		orientation.class_date >= Date.today
	end

  def self.is_not_past(orientation)
    date = orientation.class_date
    time = Time.parse(orientation.class_time)
    datetime = DateTime.parse([ date, time ].join(' '))
    datetime > Time.now
  end

	def friendly_date
		class_date.to_date.strftime('%A, %B %d')
	end

	def get_valid_registrations
		#return registrations where cancelled is false
		#self.registrations.where(cancelled: false).count
		Registration.where(cancelled: false, orientation_id: self).count
	end
end
