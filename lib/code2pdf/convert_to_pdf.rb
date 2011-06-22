class ConvertToPDF
  def initialize(filename, code_files)
    @filename, @code_files = filename, code_files
    @htmlname = @filename.gsub(".pdf",".html")
  end

  def pdf
    @code_files.each do |file|
      puts "Converting to PDF => #{file.first}"
      File.open @htmlname, "a+" do |f|
        f << "File: <strong>#{file.first}</strong>\n#{file.last}"
      end
    end
    `wkhtmltopdf #{@htmlname} #{@filename}`
    File.delete @htmlname
  end
end
