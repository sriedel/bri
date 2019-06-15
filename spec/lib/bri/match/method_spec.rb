require 'spec_helper'

describe Bri::Match::Method do
  let( :fake_paragraph ) do
    RDoc::Markup::Paragraph.new "This is line one", "This is line two" 
  end

  let( :fake_description ) do
    double( RDoc::Markup::Document, :parts => [ fake_paragraph ] )
  end

  let( :rdoc_method ) do
    double( RDoc::AnyMethod, :full_name => "This::IS::My.full_name",
                           :arglists => "First\nSecond\nThird",
                           :comment => fake_description )
  end

  describe "#initialize" do
    subject { Bri::Match::Method.new( rdoc_method ) }

    its( :full_name ) { should == rdoc_method.full_name }
    its( :call_syntaxes ) { should == "  First\n  Second\n  Third\n" }
    its( :description_paragraphs ) { should == [ "  This is line one This is line two" ] }
  end

  describe "#full_name" do
    subject do 
      search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method" )
      search_instance.search( :fully_qualified )
      search_instance.matches.first
    end
    
    its( :full_name ) { should == "BriDummySpecClass#bri_dummy_spec_instance_method" }
  end

  describe "#call_syntaxes" do
    context "for methods with no arguments" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end
      
      its( :call_syntaxes ) { should == "  bri_dummy_spec_instance_method()\n" }
    end

    context "for methods with arguments" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method_with_arguments" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end
      
      its( :call_syntaxes ) { should == "  bri_dummy_spec_instance_method_with_arguments( a, b )\n" }
    end

    context "for methods with default arguments" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method_with_default_arguments" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end
      
      its( :call_syntaxes ) { should == "  bri_dummy_spec_instance_method_with_default_arguments( a, b, c = nil )\n" }
    end

    context "for methods that yield" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method_which_yields" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end
      
      its( :call_syntaxes ) { should == "  bri_dummy_spec_instance_method_which_yields() { |yield_param_one, yield_param_two| ... }\n" }
    end

    context "for methods with an rdoc yield override" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method_with_yield_override" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end
      
      its( :call_syntaxes ) { should == "  bri_dummy_spec_instance_method_with_yield_override() { |foo, bar| ... }\n" }
    end
  end

  describe "#description_paragraphs" do
    context "for an undocumented method" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#bri_dummy_spec_instance_method" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end

      its( :description_paragraphs ) { should == [] }
    end

    context "for a documented method" do
      subject do 
        search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass#basic_headline_and_paragraph_rendering_test_method" )
        search_instance.search( :fully_qualified )
        search_instance.matches.first
      end

      its( :description_paragraphs ) { should_not be_empty }
      it "should contain rendered paragraphs as the array elements" do
        subject.description_paragraphs.first.should =~ /This is a headline/
      end
    end
  end
end
