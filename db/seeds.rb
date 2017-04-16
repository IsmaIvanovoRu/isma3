# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup').
#
# Examples:
#
#   cities = City.create([{name: ''Chicago' }', '{name: ''Copenhagen' }]')
#   Mayor.create(name: ''Emanuel'', 'city: 'cities.first')

AchievementCategory.create(name: "Учеба", description: "именные стипендии, премии, грамоты, медали и т. п., полученные за особые успехи в учебе")
AchievementCategory.create(name: "Наука", description: "конференции, гранты, научные конкурсы, выставки, патенты и прочие достижения в научной сфере")
AchievementCategory.create(name: "Спорт", description: "соревнования, конкурсы, значки ГТО и т.п.")
AchievementCategory.create(name: "Общественная деятельность", description: "волонтерство, творчество, политика и прочие достижения в общественной сфере")
AchievementCategory.create(name: "Прочее", description: "различные достижения, не относящиеся ни к одной из перечисленных категорий")
AchievementResult.create(name: "Победитель")
AchievementResult.create(name: "Призер")
AchievementResult.create(name: "Участник")
DivisionType.create(id: 6, name: "student")
