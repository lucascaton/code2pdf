$:.push File.expand_path('../lib', __FILE__)
require 'code2pdf/version'

Gem::Specification.new do |s|
  s.name        = 'code2pdf'
  s.version     = Code2pdf::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w(Lucas Caton)
  s.homepage    = 'https://blog.lucascaton.com.br/'
  s.summary     = 'Convert your source code to PDF'
  s.description = 'Convert your source code to PDF'

  s.add_dependency 'prawn', '~> 0.12.0'
  s.add_development_dependency 'rspec'

  s.rubyforge_project = 'code2pdf'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
end
