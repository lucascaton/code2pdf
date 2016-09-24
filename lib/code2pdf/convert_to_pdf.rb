class ConvertToPDF
  PDF_OPTIONS = {
    :page_size => 'A4'
  }

  def initialize(params={})
    if !params.has_key?(:from) || params[:from].nil?
      raise ArgumentError.new 'where is the codebase you want to convert to PDF?'
    elsif !valid_directory?(params[:from])
      raise LoadError.new "#{params[:from]} not found"
    elsif !params.has_key?(:to) || params[:to].nil?
      raise ArgumentError.new 'where should I save the generated pdf file?'
    else
      @from, @to = params[:from], params[:to]

      if params.has_key?(:except)
        @except = params[:except]
        raise LoadError.new "#{@except} is not a valid blacklist YAML file" unless valid_blacklist?
      end

      save
    end
  end

  private

  def pdf
    Prawn::Document.new PDF_OPTIONS do |pdf|
      read_files.each do |file|
        puts "Converting to PDF => #{file.first}"
        pdf.font 'Courier' do
          pdf.text "<strong>File: #{file.first}</strong>", :size => 12, :inline_format => true
          pdf.move_down 20
          pdf.text file.last, :size => 12, :inline_format => true
          pdf.move_down 40
        end
      end
    end
  end

  def save
    pdf.render_file @to
  end

  def valid_blacklist?
    return false if not File.exists?(@except) or FileTest.directory?(@except)
    @blacklist = YAML.load(File.read(@except))
    @blacklist.has_key?(:directories) && @blacklist.has_key?(:files)
  end

  def in_directory_blacklist?(item_path)
    @blacklist[:directories].include?(item_path.gsub("#{@from}/", '')) if @blacklist
  end

  def in_file_blacklist?(item_path)
    if @blacklist
      @blacklist[:files].include?(item_path.split('/').last) || @blacklist[:files].include?(item_path.gsub("#{@from}/", ''))
    end
  end

  def valid_directory?(dir)
    File.exists?(dir) && FileTest.directory?(dir)
  end

  def valid_file?(file)
    File.exists?(file) && FileTest.file?(file)
  end

  def read_files(path = nil)
    @files ||= []
    path   ||= @from

    Dir.foreach(path) do |item|
      item_path = "#{path}/#{item}"

      if valid_directory?(item_path) && !['.', '..'].include?(item)
        read_files(item_path) unless in_directory_blacklist?(item_path)
      elsif valid_file?(item_path)
        unless in_file_blacklist?(item_path)
          content = process_file(item_path)
          @files << [item_path, content]
        end
      end
    end

    @files
  end

  def process_file(file)
    content = ''
    File.open(file, 'r') do |f|
      f.each_line.with_index do |line_content, line_number|
        content << line_content.gsub(/</,'&lt;').gsub(/^/, "<color rgb='AAAAAA'>#{line_number + 1}</color>  ")
      end
    end
    content
  end
end
