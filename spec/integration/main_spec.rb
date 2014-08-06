require 'spec_helper'

describe 'home/index page' do
  it 'displays calendar' do
    visit '/'
    page.should have_content('Sunday')
  end
end

describe 'register new admin user' do
  it 'registers new user' do
		create_admin

    #create new orientation
		visit '/orientations/new'
		page.should have_content("New orientation")
		choose("selection_repeating")
		fill_in('from_date', :with => Date.today)
		fill_in('to_date', :with => Date.today + 5)
		fill_in('orientation_class_time', :with => '3:00pm')
		fill_in('orientation_seats', :with => '3')
		click_button "Create Orientation"
    page.should have_content("Orientation was successfully created.")

		#register for an orientation
    visit '/orientations/1/registrations/new'
		fill_in('registration_first_name', :with => 'Thomas')
		fill_in('registration_last_name', :with => 'Magnum')
		fill_in('registration_email', :with => 'magnumpi@gmail.com')
		fill_in('registration_student_id', :with => '3344992')
		fill_in('registration_phone', :with => '8283343322')
		click_button "Register"
    page.should have_content("You have successfully registered for New Student Orientation on")

		#go back to index and verify registration numbers have changed
		visit '/'
    page.should have_content("(2/3)")

		#verify more than one visit was created
    visit '/orientations/2/registrations/new'

		#go to registrations page and verify student is in list
		visit '/orientations/1/registrations'
    page.should have_content("Thomas Magnum")

		#fill up a class and verify 'Class Full' displays
		2.times do
			create_registration
		end
		visit '/'
    page.should have_content("(0/3)")
		#TODO need something here to verify that a class is full; possibly check html for strike through

		#test registration cancellation
		visit '/cancel_registration'
    page.should have_content("would like to cancel a registration please enter your registration email")
		fill_in('email', :with => 'wintas@bustasc.om')
  	#click_button "Send Email"
    #page.should have_content("Email sent with cancellation instructions.")
  end
end

describe 'register for online section' do
  it 'registers a student' do
    visit '/registrations/online'
    page.should have_content('First name')
		create_online_registration	
  	page.should have_content("You have successfully registered for the online New Student Orientation (NSO)")
  end

  it 'admin can view online registrations' do
		visit '/admin'
  	fill_in('email', :with => 'admin@abtech.edu')
  	fill_in('password', :with => 'test')
  	click_button "Log In"
  	page.should have_content("Successfully logged in!")
		visit '/registrations'
  	page.should have_content("Email")
		click_link 'Show Calendar'
		click_link 'Log Out'
  	page.should have_content("Logged out!")
  end
  it 'does not display enrollment numbers when not logged in' do
		visit '/'
    page.should have_no_content("(0/3)")
	end
end

def create_registration
  random_number = rand(9999999).to_s.center(7, rand(9).to_s)
  visit '/orientations/1/registrations/new'
  fill_in('registration_first_name', :with => Faker::Name.first_name)
  fill_in('registration_last_name', :with => Faker::Name.last_name)
  fill_in('registration_email', :with => Faker::Internet.email)
  fill_in('registration_student_id', :with => random_number)
  fill_in('registration_phone', :with => Faker::PhoneNumber.phone_number)
  click_button "Register"
end

def create_online_registration
  random_number = rand(9999999).to_s.center(7, rand(9).to_s)
  fill_in('registration_first_name', :with => Faker::Name.first_name)
  fill_in('registration_last_name', :with => Faker::Name.last_name)
  fill_in('registration_email', :with => Faker::Internet.email)
  fill_in('registration_student_id', :with => random_number)
  fill_in('registration_phone', :with => Faker::PhoneNumber.phone_number)
  click_button "Register"
end

def create_admin
	visit '/signup'
	fill_in "user_email", :with => "admin@abtech.edu"
	fill_in "user_password", :with => "test"
	fill_in "user_password_confirmation", :with => "test"
	click_button "Sign Up"
  page.should have_content("Thank you for signing up!")
	u = User.first
	u.role = 'admin'
	u.save
end

def create_pages
	visit '/pages/new'
  fill_in('page_name', :with => 'Scheduling Text')
  fill_in('page_content', :with => 'You have successfully registered for New Student Orientation on')
  click_button "Create Page"
  page.should have_content("Page was successfully created.")
	visit '/pages/new'
  fill_in('page_name', :with => 'New Online Registration')
  fill_in('page_content', :with => 'Congratulations! You have successfully registered for the online
																		New Student Orientation (NSO), which is offered through Moodle')
  click_button "Create Page"
end
