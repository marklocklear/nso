task :create_registrations => :environment do
  require 'populator'
  require 'faker'
	10.times do
	Registration.create(:orientation_id => 31,
                :first_name => Populator.words(1).titleize,
                :last_name => Populator.words(1).titleize,
                :email => 'marklocklear@gmail.com',
                :student_id => '2434232',
                :phone => '3883338833')
	end
end
