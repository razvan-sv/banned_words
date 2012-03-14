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
      Storage::FileStore.write_to_storage("something")
      Storage::FileStore.list_contents.should == "something"
    end
  end
  
  context ".list_contents" do
    
  end
  
  context ".list_contents!" do
    
  end
  
  context ".empty_storage" do
    
  end
  
  context ".empty_storage!" do
    
  end
end
