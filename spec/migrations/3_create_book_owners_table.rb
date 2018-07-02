class CreateBookOwnersTable < Migration
  def change
    create_table :book_owners do |t|
      if ActiveRecord::VERSION::STRING >= '5.0.0'
        # Rails 5 automatically adds an index for belongs_to associations. Turn
        # this behaviour off, so we can manually add the index in a later
        # migration and test adding an index via Rein.
        t.belongs_to :book, null: false, index: false
      else
        t.belongs_to :book, null: false
      end
      t.tsrange :owned_during, null: false
      t.integer :owner_id, null: false
    end
  end
end
