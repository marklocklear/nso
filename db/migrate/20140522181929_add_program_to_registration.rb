class AddProgramToRegistration < ActiveRecord::Migration
  def change
		change_table :registrations do |t|
			t.text :program
		end
  end
end
