# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ArticleType.create(name: 'articles')
ArticleType.create(name: 'anounses')
ArticleType.create(name: 'news')
Group.create(name: 'administrators', administrator: true, moderator: true, writer: true, reader: true, commentator: true)
Group.create(name: 'moderator', administrator: false, moderator: true, writer: true, reader: true, commentator: true)
Group.create(name: 'writer', administrator: false, moderator: false, writer: true, reader: true, commentator: true)
Group.create(name: 'reader', administrator: false, moderator: false, writer: false, reader: true, commentator: false)
Group.create(name: 'commentator', administrator: false, moderator: false, writer: false, reader: true, commentator: true)
Group.create(name: 'isma')
Group.create(name: 'students', parent_id: 5)
Group.create(name: 'employees', parent_id: 5)
Group.create(name: 'guests')
DivisionType.create(name: 'chairs')
DivisionType.create(name: 'students')
DivisionType.create(name: 'support')
DivisionType.create(name: 'managment')