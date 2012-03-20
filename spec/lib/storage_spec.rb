require "spec_helper"

describe Storage::FileStore do

  context ".storage_exists?" do
    it "exists" do
      Storage::FileStore.storage_exists?.should be_true
    end
    it "doesn't exist" do
      Storage::FileStore.remove_storage_file
      Storage::FileStore.storage_exists?.should be_false
    end
  end

  context ".write_to_storage" do
    it "writes something" do
      add_and_check("something")
    end
  end

  context ".list_contents" do
    it "returns no elements" do
      Storage::FileStore.list_contents.should == {}
    end
    it "returns one element" do
      add_and_check("cat")
    end
  end

  context ".list_contents!" do
    it "returns one element" do
      Storage::FileStore.write_to_storage("cat")
      Storage::FileStore.list_contents!.should == "cat"
    end

    it "raises IOError" do
      Storage::FileStore.remove_storage_file
      expect { Storage::FileStore.list_contents! }.to raise_error(IOError, "No banned words file!")
      Storage::FileStore.ensure_storage_file
    end
  end

  context ".empty_storage" do
    it "cleares all data" do
      add_and_check("cat")
      Storage::FileStore.empty_storage
      Storage::FileStore.list_contents.should == {}
    end
  end

  context ".empty_storage!" do
    it "cleares all data" do
      add_and_check("cat")
      Storage::FileStore.empty_storage!
      Storage::FileStore.list_contents.should == {}
    end

    it "raises IOError" do
      Storage::FileStore.remove_storage_file
      expect { Storage::FileStore.empty_storage! }.to raise_error(IOError, "No banned words file!")
      Storage::FileStore.ensure_storage_file
    end
  end

  context "aliases" do
    context ".new_storage" do
      it "behaves like .empty_storage with default parameter" do
        ["new_storage", "empty_storage"].each do |method|
          add_and_check("cat")
          Storage::FileStore.send(method)
          Storage::FileStore.list_contents.should == {}
        end
      end
    end

    context ".load_storage" do
      it "behaves like .list_contents" do
        Storage::FileStore.write_to_storage("mouse")
        Storage::FileStore.load_storage.should == Storage::FileStore.list_contents
      end
    end
  end

  private

  def add_and_check(word)
    Storage::FileStore.write_to_storage(word)
    Storage::FileStore.list_contents.should == word
  end
end
