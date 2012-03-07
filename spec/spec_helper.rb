require "yaml"
require "banned_words"

RSpec.configure do |config|
  config.before { stub_file_path }
  config.after  { clear_banned_words_file }
end

def stub_file_path
  Storage::FileStore.stub(:file_path).and_return("#{File.dirname(__FILE__)}/yamls/banned_words.yml")
end

def clear_banned_words_file
  BannedWords.clear
end