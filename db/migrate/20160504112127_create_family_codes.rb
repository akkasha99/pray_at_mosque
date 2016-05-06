class CreateFamilyCodes < ActiveRecord::Migration
  def change
    create_table :family_codes do |t|
      t.references :user, index: true, foreign_key: true
      t.string :code, :null => false
      t.timestamps null: false
    end
  end
end
