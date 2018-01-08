require File.expand_path('../lib/code2pdf/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name                  = 'code2pdf'
  gem.summary               = 'Convert your source code to PDF'
  gem.description           = 'Convert your source code to PDF'
  gem.authors               = ['Lucas Caton']
  gem.platform              = Gem::Platform::RUBY
  gem.version               = Code2pdf::VERSION
  gem.required_ruby_version = '>= 2.0.0'
  gem.files                 = `git ls-files`.split("\n")
  gem.test_files            = `git ls-files -- {spec}/*`.split("\n")
  gem.executables           = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  gem.require_paths         = %w[lib]

  gem.add_dependency 'pdfkit'
  gem.add_dependency 'wkhtmltopdf-binary'
  gem.add_dependency 'rouge'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pdf-inspector'
end
