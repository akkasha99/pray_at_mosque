# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "_____________________Deleting Existed Roles______________________"
Role.destroy_all if Role.all.length > 0
puts "_______________Existed Roles Deleted Successfully________________"


puts "************************Adding Roles****************************"
%w(super_admin parent child mosque).each do |role|
  Role.create(:name => role)
end
puts "*******************Roles Added Successfully*********************"

puts "------------------------Adding Admin----------------------------"
role = Role.where(:name => "super_admin").first
User.create!(:first_name => "admin", :email => "super_admin@prayatmosque.com", :password => "prayatmosque2016", :role_id => role.id)
puts "-------------------Admin Added Successfully---------------------"
