module ApplicationHelper
  def sanitize_full(text)
    options = Sanitize::Config.merge(Sanitize::Config::RELAXED, 
                                     attributes: {'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ["target"], all: Sanitize::Config::RELAXED[:attributes][:all] + ['itemprop', 'itemscope', 'itemtype']})
    if text =~ /(youtu.be|youtube.com)/ 
      if action_name == 'show'
	options = Sanitize::Config.merge(Sanitize::Config::RELAXED,
                                     attributes: {'a' => Sanitize::Config::RELAXED[:attributes]['a'] + ["target"], 'iframe' => ['width', 'height', 'src', 'frameborder', 'allowfullscreen', 'style']},
	                             elements: Sanitize::Config::RELAXED[:elements] + ['iframe'])
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
    remove_youtube(text)
    truncate(Sanitize.clean(text), :length => 300, :omission => '... ', :separator => ' ')
  end
  
  def first_letter_upcase(string)
    string[0] = string[0].mb_chars.upcase
    return string
  end

  def autosub_details(text)
    if text.include? "&amp;["
      begin
        start_text = text.clone
        @details_hash.each do |k, v|
          if v[:tag_type] && v[:tag_name]
            case v[:tag_type].to_s
            when 'itemprop'
              s = "itemprop=\"#{v[:tag_name]}\""
            when 'itemtype'
              s = "itemscope itemtype=\"http://obrnadzor.gov.ru/microformats/#{v[:tag_name]}\""
            end
            v[:block] ? text.gsub!("&amp;[#{k}]", "<div #{s}>#{v[:value].to_s}</div>") : text.gsub!("&amp;[#{k}]", "<span #{s}>#{v[:value].to_s}</span>")
          else
            text.gsub!("&amp;[#{k}]", v[:value].to_s)
          end
        end
      end while text.include?("&amp;[") && start_text != text
    end
    text
  end
  
    def autosub_details_in_title(text)
    @details_hash.each{|k, v| text.gsub!("&[#{k}]", v[:value].to_s)} if text.include? "&["
    text
  end
 
  def multi_number_to_phone(numbers, options = {})
    return unless numbers
    s = []
    numbers.split(';').each{|number| s += [number_to_phone(number, options)]}
    s.join(', ')
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
