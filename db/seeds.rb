# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup').
#
# Examples:
#
#   cities = City.create([{name: ''Chicago' }', '{name: ''Copenhagen' }]')
#   Mayor.create(name: ''Emanuel'', 'city: 'cities.first')

(Group.where(name: 'students').first.users - (Group.where(name: 'employees').first.users & Group.where(name: 'students').first.users)).each{|i| i.destroy}
Group.find_by_name('students').destroy
Division.joins(:division_type).where(division_types: {name: 'student'}).each{|i| i.destroy}
DivisionType.find_by_name('student').destroy
Article.where(user_id: nil).each{|i| i.destroy}
Post.where(user_id: nil).each{|i| i.destroy}
Profile.where(user_id: nil).each{|p| p.destroy}
