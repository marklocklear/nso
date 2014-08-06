require 'spec_helper'
describe 'destroy registration' do
  it 'creates admin user and new registration' do

  end
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


