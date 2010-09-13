require 'spec_helper'

describe Bri do
  context "a query with one result" do
    it "should show the methods description"
  end

  context "a query with multiple results" do
    it "should list fully qualified matching method names"
  end

  context "a query with no results" do
    before( :each ) do
      Bri::Matcher.stub!( :find ).and_return( [] )
    end

    it "should say nothing matched" do
      Bri.ri( "I#dont_exist" ).should == "No matching results found"
    end
  end
end
