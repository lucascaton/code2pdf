class ConvertToPDF
  PDF_OPTIONS = {
    :page_size   => 'A4'
  }

  def initialize(params={})
    if not params.has_key?(:from) or params[:from].nil?
      raise ArgumentError.new 'where are the codes you want to convert to pdf?'
    elsif not valid_directory?(params[:from])
      raise LoadError.new "#{params[:from]} not found"
    elsif not params.has_key?(:to) or params[:to].nil?
      raise ArgumentError.new 'where should I save the generated pdf file?'
    else
      @from, @to = params[:from], params[:to]
      if params.has_key?(:except)
        @except = params[:except]
        raise LoadError.new "#{@except} is not a valid blacklist yaml file" unless valid_blacklist?
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
    @blacklist.has_key?(:directories) and @blacklist.has_key?(:files)
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

  def read_files(path=nil)
    @files ||= []
    path ||= @from
    Dir.foreach(path) do |item|
      item_path = "#{path}/#{item}"

      if valid_directory?(item_path) and not ['.', '..'].include?(item)
        unless in_directory_blacklist?(item_path)
          read_files(item_path)
        end
      elsif valid_file?(item_path)
        unless in_file_blacklist?(item_path)
          content = processing_file(item_path)
          @files << [item_path, content]
        end
      end
    end
    @files
  end

  def processing_file(file)
    content = ''
    File.open(file,'r') do |f|
      f.each_line.with_index do |line_content, line_number|
        # FIXME: please, refactore me!
        content << line_content.gsub(/</,'&lt;').gsub(/^/, "<color rgb='AAAAAA'>#{line_number + 1}</color>  ")
      end
    end
    content
  end
end
