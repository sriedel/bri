require 'spec_helper'

describe Bri::Search::InstanceMethod do
  context "the searches" do
    let( :paragraph ) { RDoc::Markup::Paragraph.new( "Foo Description" ) }
    let( :document ) { double( RDoc::Markup::Document, :parts => [ paragraph ] ) }
    let( :rdoc_method ) { double( RDoc::AnyMethod, :full_name => "Foo",
                                                 :arglists => "",
                                                 :comment => document ) }
    before( :each ) do
      store_one = double( RDoc::RI::Store, :load_cache       => true,
                                         :load_class       => true,
                                         :load_method      => rdoc_method,
                                         :friendly_path    => "ruby core",
                                         :modules          => %w{ ClassThree },
                                         :instance_methods => { "ClassThree" => [ "method" ] } )
      store_two = double( RDoc::RI::Store, :load_cache       => true,
                                         :load_class       => true,
                                         :load_method      => rdoc_method,
                                         :friendly_path    => "ruby core",
                                         :modules          => %w{ ClassOne ClassTwo },
                                         :instance_methods => { "ClassOne" => [ "method" ],
                                                             "ClassTwo" => [ "method", "my_other_method" ] } )
      allow(Bri::Mall.instance).to receive(:stores).and_return( [ store_one, store_two ] )
      allow(Bri::Match::Class).to receive( :new ).and_return( double( Bri::Match::Class ) )
    end

    describe "a fully qualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::InstanceMethod.new( "I::Dont::Exist#go_away" ) }
        it "should have no matches" do
          subject.search( :fully_qualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        subject { Bri::Search::InstanceMethod.new( "ClassOne#method" ) }
        it "should have a match for each method" do
          subject.search( :fully_qualified )
          subject.matches.size.should == 1
        end
      end
    end

    describe "a partially qualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::InstanceMethod.new( "#go_away" ) }
        it "should have no matches" do
          subject.search( :partially_qualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        subject { Bri::Search::InstanceMethod.new( "#method" ) }
        it "should have a match for each method" do
          subject.search( :partially_qualified )
          subject.matches.size.should == 3
        end
      end
    end

    describe "an unqualified search" do 
      context "if there are no matching methods in any store" do
        subject { Bri::Search::InstanceMethod.new( "go_away" ) }
        it "should have no matches" do
          subject.search( :unqualified )
          subject.matches.should == []
        end
      end

      context "if there are matching methods in the stores" do
        context "if there are matching methods, where the match starts at the beginning of the method name" do
          subject { Bri::Search::InstanceMethod.new( "method" ) }
          it "should have a match for each method" do
            subject.search( :unqualified )
            subject.matches.size.should == 3
          end
        end

        context "if there are matching methods, but none where the match starts at the beginning of the method name" do
          subject { Bri::Search::InstanceMethod.new( "other" ) }
          it "should have a match for each method" do
            subject.search( :unqualified )
            subject.matches.size.should == 1
          end
        end
      end
    end
  end

  context "real searches going through rdoc" do
    context "a fully qualified search" do
      context "with no matching methods" do
        it "should have no matches" do
          search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#i_dont_exist" )
          search_instance.search( :fully_qualified )
          search_instance.matches.should be_empty
        end
      end

      context "with a matching method" do
        it "should have a match" do
          search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method" )
          search_instance.search( :fully_qualified )
          search_instance.matches.should_not be_empty
          search_instance.matches.first.full_name.should == "BriDummySpecClass#bri_dummy_spec_instance_method"
        end
      end
    end

    context "a partially qualified search" do
      context "with no matching methods" do
        it "should have no matches" do
          search_instance = Bri::Search::InstanceMethod.new( "#i_dont_exist" )
          search_instance.search( :partially_qualified )
          search_instance.matches.should be_empty
        end
      end

      context "with one matching method" do
        it "should have one match" do
          search_instance = Bri::Search::InstanceMethod.new( "#bri_dummy_spec_instance_method" )
          search_instance.search( :partially_qualified )
          search_instance.matches.should_not be_empty
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method" }.should be(true)
        end
      end

      context "with multiple matching methods" do
        it "should have all matches" do
          search_instance = Bri::Search::InstanceMethod.new( "#bri_dummy_spec_instance_method_with_arguments" )
          search_instance.search( :partially_qualified )
          search_instance.matches.should_not be_empty
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method_with_arguments" }.should be(true)
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClassTwo#bri_dummy_spec_instance_method_with_arguments" }.should be(true)
        end
      end
    end

    context "an unqualified search" do
      context "with no matching methods" do
        it "should have no matches" do
          search_instance = Bri::Search::InstanceMethod.new( "i_dont_exist_go_away" )
          search_instance.search( :unqualified )
          search_instance.matches.should be_empty
        end
      end

      context "with one matching method" do
        it "should have one match" do
          search_instance = Bri::Search::InstanceMethod.new( "bri_dummy_spec_instance_method" )
          search_instance.search( :unqualified )
          search_instance.matches.should_not be_empty
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method" }.should be(true)
        end
      end

      context "with multiple matching methods" do
        it "should have all matches" do
          search_instance = Bri::Search::InstanceMethod.new( "bri_dummy_spec" )
          search_instance.search( :unqualified )
          search_instance.matches.should_not be_empty
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method" }.should be(true)
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method_with_arguments" }.should be(true)
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClassTwo#bri_dummy_spec_instance_method_with_arguments" }.should be(true)
          search_instance.matches.any? { |match| match.full_name == "BriDummySpecClass#bri_dummy_spec_instance_method_with_default_arguments" }.should be(true)
        end
      end
    end
  end
end
