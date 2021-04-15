EducationalProgram.where(level: 'специалите').update_all(level: '')
EducationalProgram.where(level: 'ординатура').update_all(level: '')
EducationalProgram.where(level: 'аспирантура').update_all(level: '')
EducationalProgram.where(level: 'дополнительное образование').update_all(level: 'дополнительное профессиональное образование')

attachments = Attachment.select(:id, :user_id, :title).all
nn = attachments.size
n = 1
attachments.each do |attachment|
  puts "вложение #{n} из #{nn}"
  attachment.record_timestamps = false
  unless attachment.achievements.empty?
    attachment.update_attributes(user_id: attachment.achievements.first.user_id)
  end
  unless attachment.profiles.empty?
    attachment.update_attributes(user_id: attachment.profiles.first.user_id)
  end
  unless attachment.articles.empty?
    attachment.update_attributes(user_id: attachment.articles.first.user_id)
  end
  attachment.record_timestamps = true
  puts attachment.user ? "вложение #{attachment.title} - владелец #{attachment.user.profile.full_name}" : 'владелец не установлен ('
  n += 1
end
