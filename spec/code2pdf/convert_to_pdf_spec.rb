require 'spec_helper'
require 'digest/md5'

describe ConvertToPDF do
  describe '#pdf' do
    it 'creates a PDF file containing all desired source code' do
      path      = 'spec/fixtures/hello_world'
      pdf       = 'spec/fixtures/hello_world.pdf'
      blacklist = 'spec/fixtures/hello_world/.code2pdf'

      ConvertToPDF.new from: path, to: pdf, except: blacklist
      Digest::MD5.hexdigest(File.read(pdf)).should eq('a8fd2fe3b1fef17f6e13972ff1623ecb')
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
end
