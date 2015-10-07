class CreateImeis < ActiveRecord::Migration
  def change
    create_table :imeis do |t|
      t.integer :user_id
      t.string :number
      t.boolean :private, default: true

      t.timestamps null: false
    end
  end
end
