require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('banned_words', '0.1.0') do |p|
  p.description    = "Detects and masks banned words within a text"
  p.url            = "https://github.com/razvan-sv/banned_words"
  p.author         = ["Razvan Secara", "Sabina Pop"]
  p.email          = ""
  p.ignore_pattern = ["tmp/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }