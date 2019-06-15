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
        store_one = double( RDoc::Store, :load_cache    => true,
                                         :load_class    => true,
                                         :friendly_path => "ruby core",
                                         :module_names  => %w{ ClassThree } )
        store_two = double( RDoc::Store, :load_cache    => true,
                                         :load_class    => true,
                                         :friendly_path => "ruby core",
                                         :module_names  => %w{ ClassOne ClassTwo } )
        allow(Bri::Mall.instance).to receive( :stores ).and_return( [ store_one, store_two ] )
        allow(Bri::Match::Class).to receive( :new ).and_return( double( Bri::Match::Class ) )
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
          subject.matches.any?{ |match| match.name == "BriDummySpecClass < Object" }.should be(true)
        end
      end
      
      context "when searching for the class IAmQuiteCertainIDontExist" do
        subject { Bri::Search::Class.new( "IAmQuiteCertainIDontExist" ) }

        it "should not have any matches" do
          subject.search
          subject.matches.any? { |match| match.name == "IAmQuiteCertainIDontExist" }.should be(false)
        end
      end
    end
  end
end
