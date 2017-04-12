class CreateAuthorsTable < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.timestamps null: false
    end
  end
end
