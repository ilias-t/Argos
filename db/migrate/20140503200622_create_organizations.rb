class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string "name"
      t.string "crunchbase_id"
      t.string "sector"
      t.timestamps
    end
  end
end
