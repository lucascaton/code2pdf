require 'cgi'
require 'shellwords'

class ConvertToPDF
  PDF_OPTIONS = {
    page_size: 'A4'
  }.freeze

  def initialize(params = {})
    if !params.key?(:from) || params[:from].nil?
      raise ArgumentError.new 'where is the codebase you want to convert to PDF?'
    elsif !valid_directory?(params[:from])
      raise LoadError.new "#{params[:from]} not found"
    elsif !params.key?(:to) || params[:to].nil?
      raise ArgumentError.new 'where should I save the generated pdf file?'
    else
      @from, @to, @except = params[:from], params[:to], params[:except].to_s

      if File.exist?(@except) && invalid_blacklist?
        raise LoadError.new "#{@except} is not a valid blacklist YAML file"
      end

      save
    end
  end

  private

  def save
    pdf.to_file(@to)
  end

  def pdf
    html ||= ''

    style = 'size: 12px; font-family: Helvetica, sans-serif; font-size: 27px'
    
    html += "<style> .table_style { font-size: 27px } </style>"

    read_files.each do |file|
      html += "<strong style='#{style}'>File: #{file.first}</strong></br></br>"
      html += prepare_line_breaks(syntax_highlight(file)).to_s
      html += add_space(30)
    end

    @kit = PDFKit.new(html, page_size: 'A4', margin_left: '0.3in', margin_right: '0.3in')
    @kit
  end

  def syntax_highlight(file)
    file_type = File.extname(file.first)[1..-1]
    file_lexer = Rouge::Lexer.find(file_type)
    return CGI.escapeHTML(file.last) unless file_lexer

    theme = Rouge::Themes::Github.new()
    formatter = Rouge::Formatters::HTMLInline.new(theme)
    formatter = Rouge::Formatters::HTMLTable.new(formatter, start_line: 1, table_class: 'table_style')
    code_data = file.last.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    formatter.format(file_lexer.lex(code_data))
  end

  def invalid_blacklist?
    return true if FileTest.directory?(@except)

    @blacklist = YAML.load_file(@except)

    !@blacklist.key?(:directories) || !@blacklist.key?(:files)
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
    File.exist?(dir) && FileTest.directory?(dir)
  end

  def valid_file?(file)
    File.exist?(file) && FileTest.file?(file)
  end

  def read_files(path = nil)
    @files ||= []
    path   ||= @from

    Dir.foreach(path) do |item|
      item_path = "#{path}/#{item}"

      if valid_directory?(item_path) && !%w[. ..].include?(item) && !in_directory_blacklist?(item_path)
        read_files(item_path)
      elsif valid_file?(item_path) && !in_file_blacklist?(item_path)
        @files << [item_path, process_file(item_path)]
      end
    end

    @files
  end

  def process_file(file)
    puts "Reading file #{file}"

    content = ''
    File.open(file, 'r') do |f|
      if `file #{file.shellescape}` !~ /text/
        content << '[binary]'
      else
        f.each_line { |line_content| content << line_content }
      end
    end
    content
  end

  def prepare_line_breaks(content)
    content.gsub(/\n/, '<br>')
  end

  def add_space(height)
    "<div style='margin-bottom: #{height}px'>&nbsp;</div>"
  end
end
