module SvedenHelper
  def full_address(address)
    address =~ /Кохма/ ? "153012, ЦФО, Ивановская область, #{address}" : "153012, ЦФО, Ивановская область, г. Иваново, #{address}"
  end
  
  def employee_posts(employee)
    employee.posts.includes(:division).joins(:division).where(divisions: {division_type_id: 3}).map{|p| [p.name, p.division.name].join(' ')}.each{|item| (item =~ /заведую/ ? item.gsub!('кафедра', '') : item.gsub!('кафедра', 'кафедры'))}.join(', ')
  end
end