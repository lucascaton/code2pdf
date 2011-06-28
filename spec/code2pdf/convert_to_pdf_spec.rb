require 'spec_helper'
require 'digest/md5'

describe ConvertToPDF do
  describe '#pdf' do
    it 'should create a PDF file containing all desired source code' do
      path      = 'spec/fixtures/hello_world'
      pdf       = 'spec/fixtures/hello_world.pdf'
      blacklist = 'spec/fixtures/hello_world/.code2pdf'
      ConvertToPDF.new :from => path, :to => pdf, :except => blacklist
      Digest::MD5.hexdigest(File.read(pdf)).should eq '269459ae6aeb1461b3d3e744e5c83844'
      File.delete(pdf)
    end

    it 'should verify if essential params are present' do
      expect{ConvertToPDF.new(:foo => 'bar')}.to raise_error ArgumentError
    end

    it 'should verify if specified path exists' do
      path = 'spec/fixtures/isto_non_existe_quevedo'
      pdf  = 'spec/fixtures/isto_non_existe_quevedo.pdf'
      expect{ConvertToPDF.new(:from => path, :to => pdf)}.to raise_error LoadError
    end

    it 'should verify if specified blacklist file is valid' do
      path      = 'spec/fixtures/hello_world'
      pdf       = 'spec/fixtures/hello_world.pdf'
      blacklist = 'spec/fixtures/purplelist.yml'
      expect{ConvertToPDF.new :from => path, :to => pdf, :except => blacklist}.to raise_error LoadError
    end
  end
end
