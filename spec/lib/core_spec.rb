require "spec_helper"

describe Core do
  let(:banned_words) { ["quick", "jumps", "dog"] }
  let(:cart_regex)   { "c[^a-zA-Z0-9]*a[^a-zA-Z0-9]*r[^a-zA-Z0-9]*t" }
  let(:phrase)       { "The q-u#-_^i!c~k brown fox j=u m p?s over the lazy dog" }

  context ".create!" do
    context "with success" do
      it "single banned word" do
        BannedWords.list.size.should == 0
        BannedWords.create!("cart").should == [cart_regex]
        list = Storage::FileStore.load_storage
        list.size.should    == 1
        list["cart"].should == cart_regex
      end
      it "array of banned words" do
        BannedWords.list.size.should == 0
        result = BannedWords.create!(banned_words)
        result.should == [
          "q[^a-zA-Z0-9]*u[^a-zA-Z0-9]*i[^a-zA-Z0-9]*c[^a-zA-Z0-9]*k",
          "j[^a-zA-Z0-9]*u[^a-zA-Z0-9]*m[^a-zA-Z0-9]*p[^a-zA-Z0-9]*s",
          "d[^a-zA-Z0-9]*o[^a-zA-Z0-9]*g"
        ]
        BannedWords.list.size.should == 3
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
      BannedWords.create!(banned_words)
    end

    context "success" do
      it "detects & masks one banned word - dog" do
        phrase     = "The dog is purple"
        new_phrase = BannedWords.mask(phrase)
        new_phrase.should == "The *Buzz* is purple"
        new_phrase.should_not include "dog"
      end
      it "detects & masks more banned words - dog, jumps, quick" do
        new_phrase = BannedWords.mask(phrase)
        new_phrase.should == "The *Buzz* brown fox *Buzz* over the lazy *Buzz*"
        banned_words.each do |bw|
          new_phrase.should_not include bw
        end
      end
      it "mask with *Bad Word*" do
        new_phrase = BannedWords.mask(phrase, "*Bad Word*")
        new_phrase.should == "The *Bad Word* brown fox *Bad Word* over the lazy *Bad Word*"
      end
      it "should not mask anything" do
        BannedWords.remove(banned_words)
        BannedWords.mask(phrase).should == phrase
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
    it "returns banned words within a text" do
      BannedWords.create!(banned_words)
      BannedWords.detect(phrase).should == ["q-u#-_^i!c~k", "j=u m p?s", "dog"]
    end
    it "doesn't find any banned words" do
      BannedWords.create!(banned_words)
      BannedWords.detect("How do you do").should == []
    end
    it "no text is supplied" do
      BannedWords.detect("").should == []
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
      BannedWords.create!(["jack", "black"])
      list = BannedWords.list
      list.size.should == 2
      list.should == ["black", "jack"]
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

  context ".remove" do
    before do
      BannedWords.create!(banned_words)
    end
    it "one banned word" do
      BannedWords.remove("dog")
      BannedWords.list.should == ["jumps", "quick"]
    end
    it "many banned words" do
      BannedWords.remove(["dog", "quick"])
      BannedWords.list.should == ["jumps"]
    end
    it "banned word not found" do
      BannedWords.remove(["ringo"])
      BannedWords.list.should == ["dog", "jumps", "quick"]
    end
  end
end