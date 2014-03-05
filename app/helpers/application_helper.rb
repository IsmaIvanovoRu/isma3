module ApplicationHelper
  def sanitize_full(text)
    options = Sanitize::Config::RELAXED
    options[:attributes]['a'].push('target')
    if text =~ /(youtu.be|youtube.com)/ 
      if action_name == 'show'
	options[:elements].push('iframe')
	options[:attributes]['iframe'] = ['width', 'height', 'src', 'frameborder', 'allowfullscreen', 'style']
	insert_youtube(text)
	else
	  remove_youtube(text)
      end
    end
    Sanitize.clean(text, options).html_safe
  end
  
  def insert_youtube(text)
    matches = text.scan(/(\S*)(youtu.be|youtube.com)(\S*)/)
    matches.each do |m|
      id = /^.*(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^<#\&\?]*).*/.match(m.join(''))[2]
      iframe = "<iframe width='30%' style='float:right; padding-left: 10px;' src='//www.youtube.com/embed/#{id}?rel=0' frameborder='0' allowfullscreen></iframe>"
      text.gsub!(m.join(''), iframe)
    end
    text
  end
  
  def remove_youtube(text)
    matches = text.scan(/(\S*)(youtu.be|youtube.com)(\S*)/)
    matches.each do |m|
      text.gsub!(m.join(''), '')
    end
    text
  end
    
  def sanitize_truncate(text)
    truncate(Sanitize.clean(text), :length => 300, :omission => '... ', :separator => ' ')
  end
  
  def first_letter_upcase(string)
    string[0] = string[0].mb_chars.upcase
    return string
  end

  def autosub_details(text)
    @details_hash.each{|k, v| text.gsub!("&amp;[#{k}]", v.to_s)} if text.include? "&amp;["
    text
  end
  
  def number_to_phone(number, options = {})
    return unless number
    @options = options.symbolize_keys

    parse_float(number, true) if options.delete(:raise)
    number_to_phone_convert(number)
  end
  
  
  def number_to_phone_convert(number)
    str  = country_code(@options[:country_code])
    str << convert_to_phone_number(number.to_s.strip)
    str << phone_ext(@options[:extension])
  end

  private

    def convert_to_phone_number(number)
      if @options[:area_code]
	convert_with_area_code(number)
      else
	convert_without_area_code(number)
      end
    end

  def convert_with_area_code(number)
    number.gsub!(/(\d{1,4})(\d{2})(\d{2})(\d{2}$)/,"(\\1) \\2#{delimiter}\\3#{delimiter}\\4")
    number
  end

    def convert_without_area_code(number)
      number.gsub!(/(\d{0,4})(\d{2})(\d{2})(\d{2})$/,"\\1#{delimiter}\\2#{delimiter}\\3#{delimiter}\\4")
      number.slice!(0, 1) if start_with_delimiter?(number)
      number
    end

    def start_with_delimiter?(number)
      delimiter.present? && number.start_with?(delimiter)
    end

    def delimiter
      @options[:delimiter] || "-"
    end

    def country_code(code)
      code.blank? ? "" : "+#{code} "
    end

    def phone_ext(ext)
      ext.blank? ? "" : " x #{ext}"
    end
end
