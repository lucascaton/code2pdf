# code2pdf

[![Gem Version](https://badge.fury.io/rb/code2pdf.svg)](https://rubygems.org/gems/code2pdf)

**code2pdf** is a simple tool for convert your source code to a PDF file.

It can be useful if you need to licence you software.

## Installation

    gem install code2pdf

## Usage

Open a terminal and run:

    code2pdf

## BlackList file example:

The blacklist file must be a yaml file named `.code2pdf`, placed in project root path, containing a list of ignored files and/or directories, such as:

```yaml
:directories:
  - .git
  - log
  - public/system
  - tmp
  - vendor
:files:
  - .DS_Store
  - database.yml
  - favicon.ico
```

## PDF output example

[example.pdf](https://github.com/lucascaton/code2pdf/raw/master/examples/example.pdf)

## Contributing

* Check out the latest master to make sure the feature hasn’t been implemented or the bug hasn’t been fixed yet
* Check out the issue tracker to make sure someone already hasn’t requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don’t break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright © 2011-2017 Lucas Caton. See LICENSE for further details.
