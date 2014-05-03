class CreateSector < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string "company"
      t.string "sector"
    end
  end
end
