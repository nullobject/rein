class CreateBooksTable < CompatibleMigration
  def change
    create_table :books do |t|
      if ActiveRecord::VERSION::STRING >= "5.0.0"
        # Rails 5 automatically adds an index for belongs_to associations.
        # Turn this behaviour off, so we can manually add the index in a
        # later migration and test adding an index via rein.
        t.belongs_to :author, null: false, index: false
      else
        t.belongs_to :author, null: false
      end
      t.string :title, null: false
      t.string :state, null: false
      t.integer :published_month, null: false
      t.date :due_date
      t.string :holder
      t.text :call_number
    end
  end
end
