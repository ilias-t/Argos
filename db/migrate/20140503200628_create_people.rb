class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string "name"
      t.string "crunchbase_id"
      t.timestamps
    end
  end
end
