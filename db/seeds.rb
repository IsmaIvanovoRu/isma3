# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup').
#
# Examples:
#
#   cities = City.create([{name: ''Chicago' }', '{name: ''Copenhagen' }]')
#   Mayor.create(name: ''Emanuel'', 'city: 'cities.first')
users = User.joins(:divisions).where("divisions.name LIKE ?", "%группа 6%")
users += User.joins(:divisions).where("divisions.name LIKE ? AND divisions.name LIKE ?", "%ординатура%", "%2 год%")
users += User.joins(:divisions).where("divisions.name LIKE ? AND divisions.name LIKE ?", "%аспирантура%", "%3 год%")
users.each do |user|
  user.groups.delete(Group.find_by_name("students"))
  user.groups.delete(Group.find_by_name("writers"))
  user.groups << Group.find_by_name("graduates")
  user.divisions.where("divisions.name LIKE ?", "%группа 6%").each{|d| d.destroy}
  user.divisions.where("divisions.name LIKE ?", "%ординатура%").each{|d| d.destroy}
  user.divisions.where("divisions.name LIKE ?", "%аспирантура%").each{|d| d.destroy}
end

Division.where("name LIKE ?", "%группа 5%").each{|d| d.update_attributes(name: d.name.gsub("5 курса", "6 курса"))}
Division.where("name LIKE ?", "%группа 4%").each{|d| d.update_attributes(name: d.name.gsub("4 курса", "5 курса"))}
Division.where("name LIKE ?", "%группа 3%").each{|d| d.update_attributes(name: d.name.gsub("3 курса", "4 курса"))}
Division.where("name LIKE ?", "%группа 2%").each{|d| d.update_attributes(name: d.name.gsub("2 курса", "3 курса"))}
Division.where("name LIKE ?", "%группа 1%").each{|d| d.update_attributes(name: d.name.gsub("1 курса", "2 курса"))}
Division.where("name LIKE ? AND name LIKE ?", "%ординатура%", "%1 год%").each{|d| d.update_attributes(name: d.name.gsub("1", "2"))}
Division.where("name LIKE ? AND name LIKE ?", "%аспирантура%", "%2 год%").each{|d| d.update_attributes(name: d.name.gsub("2", "3"))}
Division.where("name LIKE ? AND name LIKE ?", "%аспирантура%", "%1 год%").each{|d| d.update_attributes(name: d.name.gsub("1", "2"))}

