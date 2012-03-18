require 'nokogiri'
require 'html2md/document'

class Html2Md
  attr_accessor :options, :source

  def initialize(source =nil , options = {})
    @options = options
    @source = source
  end

  def parse()
    doc = Html2Md::Document.new()
    doc.relative_url = options[:relative_url]
    parser = Nokogiri::HTML::SAX::Parser.new(doc)
    parser.parse(source)
    parser.document.markdown
  end
end