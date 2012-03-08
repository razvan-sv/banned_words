require "spec_helper"

describe Core do
  let(:banned_words) {["quick", "jumps", "dog"]}

  context ".create!" do
    it "" do
    end
  end

  context ".verify" do
    before do
      banned_words.each do |word|
        BannedWords.create!(word)
      end
    end

    context "success" do
      it "detects & masks one banned word - dog" do
        phrase     = "The dog is purple"
        new_phrase = BannedWords.verify(phrase)
        new_phrase.should == "The *Buzz* is purple"
        new_phrase.should_not include "dog"
      end

      it "detects & masks more banned words - dog, jumps, quick" do
        phrase     = "The quick brown fox jumps over the lazy dog"
        new_phrase = BannedWords.verify(phrase)
        new_phrase.should == "The *Buzz* brown fox *Buzz* over the lazy *Buzz*"
        banned_words.each do |bw|
          new_phrase.should_not include bw
        end
      end
    end

    context "no changes" do
      it "cannot find any banned words" do
        phrase     = "Rock music records"
        new_phrase = BannedWords.verify(phrase)
        new_phrase.should == phrase
      end
    end

  end

  context ".list" do
    it "shows a list of all banned words" do
      #BannedWords.list
    end
  end

  context ".clear" do
    it "clears the banned words list" do
      
    end
    
    it "raises NoBannedWordsFile" do
      FileUtils.rm("#{File.dirname(__FILE__)}/../yamls/banned_words.yml")
      #lambda { BannedWords.clear }.should raise_error Core::NoBannedWordsFile
    end
  end
  
  context ".ensure_yaml_file!" do
    it "creates a banned_words.yml file" do
      File.exists?(Storage::FileStore.file_path).should == false
      BannedWords.send(:ensure_yaml_file!)
      File.exists?(Storage::FileStore.file_path).should == true
    end
  end

end