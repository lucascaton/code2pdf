require 'spec_helper'
require 'digest/md5'

describe ConvertToPDF do
  describe '#pdf' do
    it 'creates a PDF file containing all desired source code' do
      path      = 'spec/fixtures/hello_world'
      pdf       = 'spec/fixtures/hello_world.pdf'
      blacklist = 'spec/fixtures/hello_world/.code2pdf'

      ConvertToPDF.new from: path, to: pdf, except: blacklist
      file_hash = '0e016c75f2da19f8ffde91a7b8099f14'
      expect(Digest::MD5.hexdigest(File.read(pdf))).to eq(file_hash)
      File.delete(pdf)
    end

    it 'raises an error if required params are not present' do
      expect { ConvertToPDF.new(foo: 'bar') }.to raise_error(ArgumentError)
    end

    it 'raises an error if path does not exist' do
      path = 'spec/fixtures/isto_non_existe_quevedo'
      pdf  = 'spec/fixtures/isto_non_existe_quevedo.pdf'

      expect { ConvertToPDF.new(from: path, to: pdf) }.to raise_error(LoadError)
    end

    it 'raises an error if blacklist file is not valid' do
      path      = 'spec/fixtures/hello_world'
      pdf       = 'spec/fixtures/hello_world.pdf'
      blacklist = 'spec/fixtures/purplelist.yml'

      expect { ConvertToPDF.new from: path, to: pdf, except: blacklist }.to raise_error(LoadError)
    end
  end

  describe '#prepare_line_breaks' do
    before do
      from = 'spec/fixtures/hello_world'
      to = 'spec/fixtures/hello_world.pdf'
      @pdf = ConvertToPDF.new(from: from, to: to)
    end
    it 'converts strings with \n to <br> for PDF generation' do
      test_text = "test\ntest"
      expect(@pdf.send(:prepare_line_breaks, test_text)).to eq('test<br>test')
    end
  end

  describe '#syntax_highlight' do
    before do
      from = 'spec/fixtures/hello_world'
      to = 'spec/fixtures/hello_world.pdf'
      @pdf = ConvertToPDF.new(from: from, to: to)
    end
    it 'returns file with syntax_highlight html clases' do
      path = 'spec/fixtures/hello_world/lib/hello.rb'
      output = File.read('spec/fixtures/syntax_highlight.html')
      content = @pdf.send(:process_file, path)
      file = [path, content]
      expect(@pdf.send(:syntax_highlight, file)).to eq(output)
    end
  end
end
