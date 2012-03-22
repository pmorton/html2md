# encoding: utf-8
require 'rspec/expectations'
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'html2md'

Before do
  @html2md = Html2Md.new
end

After do
end

Given /HTML (.*)/ do |n|
  @html2md.source = n.gsub("\\n", "\n")
end

Given /File \((.*)\)/ do |n|
  @html2md.source = File.read(n)
end

When /I say parse/ do
  @result = @html2md.parse
end

Then /The markdown should be \((.*)\)/ do |result|
  @result.should == result.gsub("\\n", "\n")
end

Then /The mardown should be equal to \((.*)\)/ do |file|
  @result.gsub("\\n","\n").should == File.read(file)
end