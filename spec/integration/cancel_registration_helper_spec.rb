require 'spec_helper'

describe CancelRegistrationHelper do
  it 'displays cancel registration page' do
    visit '/cancel_registration'
    page.should have_content('cancel a registration')
		fill_in('email', :with => 'test@mytest.com')
		#click_button "Send Email"
    #page.should have_content("Email sent with cancellation instructions.")
  end
end
