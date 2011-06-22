# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require "code2pdf/version"

Gem::Specification.new do |s|
  s.name        = 'code2pdf'
  s.version     = Code2pdf::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Lucas Caton']
  s.email       = ['lucascaton@gmail.com']
  s.homepage    = 'http://blog.lucascaton.com.br/'
  s.summary     = %q{Convert your source code to PDF}
  s.description = %q{Convert your source code to PDF}


  s.add_development_dependency 'coderay', '>= 0.9.8'
  s.add_development_dependency 'wkhtmltopdf-binary', '>= 0.9.5.3'
  
  s.add_runtime_dependency('coderay', '>= 0.9.8')
  s.add_runtime_dependency('wkhtmltopdf-binary', '>= 0.9.5.3')

  s.rubyforge_project = 'code2pdf'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
