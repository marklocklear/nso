require 'spec_helper'

describe 'home/index page' do
puts "in main spec"
  it 'displays calendar' do
    visit '/'
    page.should have_content('Sunday')
  end
end
