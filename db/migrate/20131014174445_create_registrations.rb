class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :orientation_id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :student_id
			t.string :phone
			t.string :registration_cancellation_token
			t.datetime :registration_cancelled_at
			t.boolean :checked_in, :default => false
			t.boolean :cancelled, :default => false

      t.timestamps
    end
  end
end
