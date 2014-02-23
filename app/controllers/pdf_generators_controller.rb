class PdfGeneratorsController < ApplicationController
  def divisions
    @divisions = Division.order(:name).includes(:division_type).includes(:posts).includes(:users).all.group_by{|d| t(d.division_type.name, scope: [:divisions])}.sort
      pdf = Prawn::Document.new(page_size: "A4", :info => {
	:Title => 'IsmaDivisions ' + Time.now.to_date.to_s,
	:Creator => "ISMA",
	:Producer => "Prawn",
	:CreationDate => Time.now }
	)
      pdf.font_families.update("Ubuntu" => {
	:normal => "#{Rails.root}/vendor/fonts/Ubuntu-R.ttf",
	:italic => "#{Rails.root}/vendor/fonts/Ubuntu-RI.ttf",
	:bold => "#{Rails.root}/vendor/fonts/Ubuntu-B.ttf"
					  })
      pdf.font "Ubuntu"
      pdf.text t(:divisions, scope: :pdf_generators), :style => :bold, :size => 18
      pdf.move_down 10
      n = 0
      @divisions.each do |type, divisions|
	pdf.text type, :style => :bold, :size => 16
	divisions.each do |division|
	pdf.text division.name, :style => :bold, :size => 14
	pdf.move_down 10
	  division.head.each do |h|
	    pdf.text h.name, :size => 12 if h && h.user
	    pdf.move_down 8 if h && h.user
	    pdf.text h.user.profile.full_name_reg, :size => 12 if h.user
	    pdf.move_down 8 if h.user
	    pdf.text h.phone, :size => 12 if h && !h.phone.empty?
	    pdf.move_down 8 if h && !h.phone.empty?
	  end
	  pdf.text division.address, :size => 12 if division.address
	  pdf.move_down 8 if division.address
	  pdf.text division.email, :size => 12 if division.email
	  pdf.move_down 15
	end
      end
      string = t(:page, scope: :pdf_generators) + " <page> " + t(:of, scope: :pdf_generators) + " <total>"
      options = {:at => [pdf.bounds.right - 150, 0], :width => 150, :align => :center, :start_count_at => 1}
      pdf.number_pages string, options
      send_data pdf.render, :filename => "IsmaDivisions #{Time.now.to_date}", :type => 'application/pdf', :disposition => "inline"
  end
end
