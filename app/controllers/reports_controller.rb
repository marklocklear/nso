class ReportsController < ApplicationController
	before_filter :authorize
	def find_by_date
		@start_date = params[:from_date]
		@end_date = params[:to_date]
		@orientations = Orientation.where(class_date: @start_date..@end_date)
		@registrations = Registration.includes(:orientation).
											where(orientations: {:class_date => @start_date..@end_date})
		@online_registrations = Registration.where(:created_at => @start_date..@end_date).includes(:orientation).
											where(orientations: {:class_date => nil})
		@total_seats = 0
		@orientations.each {|o| @total_seats += o.seats}
		@canceled_registrations = @registrations.where("cancelled IS true")
		@attended_registrations = @registrations.where("checked_in IS true")
		@no_shows = @registrations.where("checked_in IS false")
		respond_to do |format|
			format.html
		end
	end
end
