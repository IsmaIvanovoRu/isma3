module SvedenHelper
  def full_address(address)
    
    address =~ /Кохма/ ? "153012, ЦФО, Ивановская область, #{address}" : "153012, ЦФО, Ивановская область, г. Иваново, #{address}"
  end
end