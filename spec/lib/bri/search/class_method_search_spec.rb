require 'spec_helper'

describe Bri::Search::ClassMethod do
  context "the searches" do
    let( :paragraph ) { RDoc::Markup::Paragraph.new( "Foo Description" ) }
    let( :document ) { mock( RDoc::Markup::Document, :parts => [ paragraph ] ) }
    let( :rdoc_method ) { mock( RDoc::AnyMethod, :full_name => "Foo",
                                                 :call_seq => "",
                                                 :comment => document ) }
    before( :each ) do
      store_one = mock( RDoc::RI::Store, :load_cache => true, 
                                         :load_class => true,
                                         :load_method => rdoc_method,
                                         :modules    => %w{ ClassThree },
                                         :class_methods => { "ClassThree" => [ "method" ] } )
      store_two = mock( RDoc::RI::Store, :load_cache => true, 
                                         :load_class => true,
                                         :load_method => rdoc_method,
                                         :modules    => %w{ ClassOne ClassTwo },
                                         :class_methods => { "ClassOne" => [ "method" ],
                                                             "ClassTwo" => [ "method", "my_other_method" ] } )
      Bri::Mall.instance.stub!( :stores => [ store_one, store_two ] )
      Bri::Match::Class.stub!( :new ).and_return( mock( Bri::Match::Class ) )
    end

    describe "a fully qualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::ClassMethod.new( "I::Dont::Exist.go_away" ) }
        it "should have no matches" do
          subject.search( :fully_qualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        subject { Bri::Search::ClassMethod.new( "ClassOne.method" ) }
        it "should have a match for each method" do
          subject.search( :fully_qualified )
          subject.matches.size.should == 1
        end
      end
    end

    describe "a partially qualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::ClassMethod.new( ".go_away" ) }
        it "should have no matches" do
          subject.search( :partially_qualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        subject { Bri::Search::ClassMethod.new( ".method" ) }
        it "should have a match for each method" do
          subject.search( :partially_qualified )
          subject.matches.size.should == 3
        end
      end
    end

    describe "an unqualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::ClassMethod.new( "go_away" ) }
        it "should have no matches" do
          subject.search( :unqualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        context "if there are matching methods, where the match starts at the beginning of the method name" do
          subject { Bri::Search::ClassMethod.new( "method" ) }
          it "should have a match for each method" do
            subject.search( :unqualified )
            subject.matches.size.should == 3
          end
        end

        context "if there are matching methods, but none where the match starts at the beginning of the method name" do
          subject { Bri::Search::ClassMethod.new( "other" ) }
          it "should have a match for each method" do
            subject.search( :unqualified )
            subject.matches.size.should == 1
          end
        end
      end
    end
  end
end
