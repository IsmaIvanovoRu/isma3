# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup').
#
# Examples:
#
#   cities = City.create([{name: ''Chicago' }', '{name: ''Copenhagen' }]')
#   Mayor.create(name: ''Emanuel'', 'city: 'cities.first')
extrants = User.joins(:divisions).where("divisions.name like ?", "%6 курса%")
extrants.each do |user|
  Group.find(7).users.delete(user)
end
Division.where("name like ?", "%6 курса педиатрического%").each{|d| d.destroy}
Division.where("name like ?", "%5 курса стоматологического%").each{|d| d.destroy}
divisions = Division.where(division_type_id: 6)
divisions.each do |division|
  name = division.name.split(' ')
  name[2] = name[2].to_i + 1
  division.update_attributes(name: name.join(' '))
end