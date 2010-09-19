require 'spec_helper'

describe Bri::Search::Class do
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

  describe "#search" do
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
end
