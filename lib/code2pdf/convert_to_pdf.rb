class ConvertToPDF

  PDF_OPTIONS = {
    :page_size   => 'A4'
  }

  def initialize(filename, code_files)
    @filename, @code_files = filename, code_files
  end

  def pdf
    Prawn::Document.new PDF_OPTIONS do |pdf|
      @code_files.each do |file|
        puts "Converting to PDF => #{file.first}"
        pdf.font 'Courier' do
          pdf.text "File: <strong>#{file.first}</strong>", :size => 12, :inline_format => true
          pdf.move_down 20
          pdf.text file.last, :size => 12, :inline_format => true
          pdf.move_down 40
        end
      end
    end
  end

  def save
    pdf.render_file @filename
  end
end
