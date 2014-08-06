class AddLocationToOrientation < ActiveRecord::Migration
  def change
    add_column :orientations, :location, :string
  end
end
