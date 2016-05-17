class AddColumnsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :search_radius, :float
    add_column :users, :parent_id, :integer
    add_column :users, :device_token, :string
    add_column :users, :is_deleted, :boolean, :default => false
    add_column :users, :is_active, :boolean, :default => true
    add_column :users, :about_me, :string
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :phone, :string
    add_column :users, :customer_id, :string
    add_column :users, :merchant_id, :string
    add_column :users, :parent_balance, :float, :default => 0.0
    add_attachment :users, :avatar
  end

  def down
    remove_column :users, :provider, :string
    remove_column :users, :uid, :string
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :search_radius, :float
    remove_column :users, :parent_id, :integer
    remove_column :users, :device_token, :string
    remove_column :users, :is_deleted, :boolean, :default => false
    remove_column :users, :is_active, :boolean, :default => true
    remove_column :users, :about_me, :string
    remove_column :users, :latitude, :float
    remove_column :users, :longitude, :float
    remove_column :users, :phone, :string
    remove_column :users, :customer_id, :string
    remove_column :users, :merchant_id, :string
    remove_column :users, :parent_balance, :float
    remove _attachment :users, :avatar
  end
end
