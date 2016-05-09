class CreateDisplayingContents < ActiveRecord::Migration
  def change
    create_table :displaying_contents do |t|
      t.text :content, :null => false
      t.string :content_type, :null => false
      t.timestamps null: false
    end
  end
end
