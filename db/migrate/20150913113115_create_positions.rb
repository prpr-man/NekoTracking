class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.text :latitude
      t.text :longitude
      t.integer :imei

      t.timestamps null: false
    end
  end
end
