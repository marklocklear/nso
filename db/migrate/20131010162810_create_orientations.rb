class CreateOrientations < ActiveRecord::Migration
  def change
    create_table :orientations do |t|
      t.date :class_date
      t.text :class_time
      t.integer :seats
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
