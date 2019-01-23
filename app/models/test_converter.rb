class TestConverter
  require 'builder'
  
  def self.mytest2moodle(input_file)
    output_file = {}
    filename = input_file.original_filename
    input_xml = Nokogiri::XML(open(input_file.path))
    output_xml = ::Builder::XmlMarkup.new(indent: 2)
    output_xml.instruct!
    output_xml.quiz do |quiz|
      input_xml.css('Task').each do |task|
        if task.css('Variants VariantText').map{|i| i.attributes.first.last.value}.count('True') == 1
          q = task.at_css('QuestionText PlainText').content
          as = task.css('Variants PlainText').map(&:content).zip(task.css('Variants VariantText').map{|i| i.attributes.first.last.value})
          quiz.question(type: "multichoice") do |question|
            question.name do |qn|
              qn.text q.slice(0, 25).strip
            end
            question.questiontext do |qt|
              qt.text q
            end
            as.each do |a|
              fraction = a.last == "True" ? 100 : 0
              question.answer(fraction: fraction) do |answer|
                answer.text a.first
              end
            end
            question.shuffleanswers 1
            question.single true
            question.answernumbering "none"
          end
        end
      end
      output_file[filename] = output_xml.target!
    end
    return output_file
  end
end
