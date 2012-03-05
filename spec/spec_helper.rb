require "yaml"
require "banned_words"

#before do
#	p "X"
#	BannedWords.stub(BW_FILE_PATH).and_return("/config/banned_words.yml")
#end

RSpec.configure do |config|
  #config.before(:suite) { BluePrints.seed }  
end