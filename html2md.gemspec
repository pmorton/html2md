$LOAD_PATH.unshift 'lib'
#require "html2md/version"

Gem::Specification.new do |s|
  s.name              = "html2md"
  s.version           = '0.1.3'
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "A library for converting basic html to markdown"
  s.homepage          = "http://github.com/pmorton/html2md"
  s.email             = "geeksitk@gmail.com"
  s.authors           = [ "Paul Morton" ]
  s.has_rdoc          = false

  s.files             = %w( README.md Rakefile LICENSE.md )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("man/**/*")
  s.files            += Dir.glob("features/**/*")

#  s.executables       = %w( #{name} )
  s.description       = <<desc
  Converts Basic HTML to markdown
desc
end
