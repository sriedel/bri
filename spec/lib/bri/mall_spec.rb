require 'spec_helper'

describe Bri::Mall do
  subject { Bri::Mall.instance }

  before( :each ) do
    RDoc::RI::Paths.stub!( :each ).
                    and_yield( "store1_path", "store1_type" ).
                    and_yield( "store2_path", "store2_type" )
    RDoc::RI::Store.stub!( :new ).
                    and_return { mock( RDoc::RI::Store, :load_cache=> true ) }
  end

  describe "the instance" do
    its( :stores ) { should have(2).objects }
  end

  describe "#classes" do
    it "should query all stores for their modules" do
      subject.stores.each do |store|
        store.should_receive( :modules ).and_return( true )
      end

      subject.classes
    end

    it "should return a sorted array of unique class names" do
      subject.stores.first.stub!( :modules => [ "C", "B", "A" ] )
      subject.stores.last.stub!( :modules => [ "Z", "B", "C" ] )
      subject.classes.should == [ "A", "B", "C", "Z" ]
    end
  end

end
