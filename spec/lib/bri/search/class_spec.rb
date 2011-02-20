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
    context "basic functionality" do
      before( :each ) do
        store_one = mock( RDoc::RI::Store, :load_cache => true, 
                                           :load_class => true,
                                           :modules => %w{ ClassThree } )
        store_two = mock( RDoc::RI::Store, :load_cache => true, 
                                           :load_class => true,
                                           :modules => %w{ ClassOne ClassTwo } )
        Bri::Mall.instance.stub!( :stores => [ store_one, store_two ] )
        Bri::Match::Class.stub!( :new ).and_return( mock( Bri::Match::Class ) )
      end

      context "if there are no matching modules in any store" do
        subject { Bri::Search::Class.new( "I::Dont::Exist" ) }
        it "should have no matches" do
          subject.search
          subject.matches.should == []
        end
      end

      context "if there is a matching module in the stores" do
        subject { Bri::Search::Class.new( "ClassOne" ) }
        it "should have a match for each name" do
          subject.search
          subject.matches.size.should == 1
        end
      end
    end

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
