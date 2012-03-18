require 'bundler/setup'
require "cucumber/rake/task"
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'html2md'

Cucumber::Rake::Task.new do |t|
  t.cucumber_opts = %w{--format pretty}
end

desc "Test"
task :t, [] => [] do |taks,args| 
  t = Html2Md.new(File.read('test.html'))
  puts t.parse
end
