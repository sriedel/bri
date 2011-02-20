require 'spec_helper'

describe Bri::Search::Class do
  describe "#initialize" do
    context "for an empty search" do
      subject { Bri::Search::Class.new( "term" ) }
      its( :term ) { should == "term" }
      its( :matches ) { should be_empty }
    end
  end

  describe "#search" do
    context "for the type :fully_qualified" do
      context "when searching for the class BriDummySpecClass" do
        subject { Bri::Search::Class.new( "BriDummySpecClass" ) }

        it "should have matches" do
          subject.search
          subject.matches.should_not be_empty
          subject.matches.any?{ |match| match.name == "BriDummySpecClass" }.should be_true
        end
      end
      
      context "when searching for the class IAmQuiteCertainIDontExist" do
        subject { Bri::Search::Class.new( "IAmQuiteCertainIDontExist" ) }

        it "should not have any matches" do
          subject.search
          subject.matches.any? { |match| match.name == "IAmQuiteCertainIDontExist" }.should be_false
        end
      end
    end
  end
end
