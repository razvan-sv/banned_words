require "spec_helper"

describe Core do
  let(:banned_words) { ["quick", "jumps", "dog"] }

  context ".create!" do
    context "with success" do
      it "adds a banned word to the storage file" do
        BannedWords.list.size.should == 0
        BannedWords.create!("punk")
        list = BannedWords.list
        list.size.should    == 1
        list["punk"].should == "p[^a-zA-Z0-9]*u[^a-zA-Z0-9]*n[^a-zA-Z0-9]*k"
      end
    end

    context "with errors" do
      it "fails to add a banned word containing more than two words" do
        BannedWords.list.size.should == 0
        BannedWords.create!("jack black")
        BannedWords.list.size.should == 0
      end
    end
  end

  context ".mask" do
    before do
      banned_words.each do |word|
        BannedWords.create!(word)
      end
    end

    context "success" do
      it "detects & masks one banned word - dog" do
        phrase     = "The dog is purple"
        new_phrase = BannedWords.mask(phrase)
        new_phrase.should == "The *Buzz* is purple"
        new_phrase.should_not include "dog"
      end

      it "detects & masks more banned words - dog, jumps, quick" do
        phrase     = "The quick brown fox jumps over the lazy dog"
        new_phrase = BannedWords.mask(phrase)
        new_phrase.should == "The *Buzz* brown fox *Buzz* over the lazy *Buzz*"
        banned_words.each do |bw|
          new_phrase.should_not include bw
        end
      end
    end

    context "no changes" do
      it "cannot find any banned words" do
        phrase     = "Rock music records"
        new_phrase = BannedWords.mask(phrase)
        new_phrase.should == phrase
      end
    end

  end

  context ".detect" do
    before do
      banned_words.each do |word|
        BannedWords.create!(word)
      end
    end
    
    it "detects - dog, jumps, quick" do
      phrase    = "The quick brown fox jumps over the lazy dog"
      bad_words = BannedWords.detect(phrase)
      bad_words.should == ["quick", "jumps", "dog"]
    end
    
    it "no banned words" do
      phrase    = "How are you?"
      bad_words = BannedWords.detect(phrase)
      bad_words.should == []
    end
    
  end
  
  context ".list" do
    it "no banned words in list" do
      BannedWords.list.size.should == 0
    end

    it "displays 2 banned words" do
      ["jack", "black"].map {|word| BannedWords.create!(word)}
      list = BannedWords.list
      list.size.should == 2
      list.keys.should == ["jack", "black"]
    end

    it "raises an error if the banned words file isn't found" do
      Storage::FileStore.remove_storage_file
      expect { BannedWords.list }.to raise_error(IOError, "No banned words file!")
    end
  end

  context ".clear" do
    it "clears the banned words list" do
      BannedWords.create!("wolf")
      BannedWords.list.size.should == 1
      BannedWords.clear
      BannedWords.list.size.should == 0
    end

    it "raises NoBannedWordsFile" do
      Storage::FileStore.remove_storage_file
      expect { BannedWords.clear }.to raise_error(IOError, "No banned words file!")
    end
  end

end