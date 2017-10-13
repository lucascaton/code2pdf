class ConvertToPDF
  PDF_OPTIONS = {
    page_size: 'A4'
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
    @html ||= ""
    @html = @html + "<style>#{Rouge::Themes::Base16.mode(:light).render(scope: '.highlight')}</style>"
    read_files.each do |file|
      @html = @html + "<strong style='size: 12'>File: #{file.first}</strong></br>"
      @html = @html + "#{prepare_line_breaks(syntax_highlight(file))}"
      @html = @html + add_space(30)
    end
   @kit = PDFKit.new(@html, :page_size => 'A4')
   @kit
  end

  def syntax_highlight(file)
    file_type = File.extname(file.first)[1..-1]
    file_lexer = Rouge::Lexer.find(file_type)
    return file.last unless file_lexer
    theme = Rouge::Themes::Base16.mode(:light)
    formatter = Rouge::Formatters::HTMLInline.new(theme)
    formatter = Rouge::Formatters::HTMLTable.new(formatter, start_line: 1)
    formatter.format(file_lexer.lex(file.last))
  end

  def save
    pdf.to_file @to
  end

  def valid_blacklist?
    return false if FileTest.directory?(@except)

    return true unless File.exists?(@except)

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
    puts "Reading file #{file}"

    content = ''
    File.open(file, 'r') do |f|
      if %x(file #{file}) !~ /text/
        content << "<color rgb='777777'>[binary]</color>"
      else
        f.each_line.with_index do |line_content, line_number|
          content << line_content
        end
      end
    end
    content
  end

  def prepare_line_breaks(content)
    content.gsub(/\n/, "<br>")
  end

  def add_space height
    "<div style='margin-bottom: #{height}px'>&nbsp;</div>"
  end
end
