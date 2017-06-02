class CreateBooksTable < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.belongs_to :author, null: false
      t.string :title, null: false
      t.string :state, null: false
      t.integer :published_month, null: false
      t.date :due_date
      t.string :holder
      t.text :call_number
    end
  end
end
