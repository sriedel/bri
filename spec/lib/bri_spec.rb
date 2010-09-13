require 'spec_helper'

describe Bri do
  subject { Bri.ri( "Some#method" ) }

  context "a query with one result" do
    it "should show the methods description"
  end

  context "a query with multiple results" do
    before( :each ) do
      Bri::Matcher.stub!( :find ).
                   and_return( [ 'A#method', 'B#method', 'C#method' ] )
    end

    it "should print a heading row" do
      header, *rest = subject.split("\n")
      header.should == '------------------------------------------------------ Multiple choices:'
    end

    it "should then list fully qualified matching method names" do
      header, dummy, *list = subject.split("\n")
      list.one? { |row| row =~ /A#method/ }.should be_true
      list.one? { |row| row =~ /B#method/ }.should be_true
      list.one? { |row| row =~ /C#method/ }.should be_true
    end
  end

  context "a query with no results" do
    before( :each ) do
      Bri::Matcher.stub!( :find ).and_return( [] )
    end

    it "should say nothing matched" do
      subject.should == "No matching results found"
    end
  end
end
