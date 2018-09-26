# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup').
#
# Examples:
#
#   cities = City.create([{name: ''Chicago' }', '{name: ''Copenhagen' }]')
#   Mayor.create(name: ''Emanuel'', 'city: 'cities.first')
a = [[25, 53, 54], [38, 66, 135], [41, 15, 347], [16, 61, 114], [63, 20, 293], [63, 68, 293]]
a.each do |i|
  new_division = i[0]
  old_division = i[1]
  new_head = i[2]
  division = Division.find_by_id(old_division)
  division.posts.each{|p| p.update_attributes(division_id: new_division, parent_id: new_head)} if division
  division = Division.find_by_id(old_division)
  division.destroy if division
end

