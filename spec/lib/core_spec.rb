require "spec_helper"

describe Core do  

  it "should have a REGEX constant" do
    Core.const_defined?(:REGEX).should == true
  end

  context ".create!" do
  end

  context ".verify" do
  end

  it "shows a list of all banned words" do
  end

  it "clears the banned words list" do
  end

end