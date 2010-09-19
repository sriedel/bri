require 'spec_helper'

describe Bri::Match::Class do
  let( :fake_paragraph ) do
    mock( RDoc::Markup::Paragraph, :parts => [ "This is row one", 
                                               "And this is row 2" ] )
  end

  let( :fake_description ) do 
    mock( RDoc::Markup::Document, :parts => [ fake_paragraph ] ) 
  end

  let( :fake_include ) do
    mock( RDoc::Include, :full_name => "Included::Module" )
  end

  let( :fake_constant ) do
    mock( RDoc::Constant, :name => "MockConstant", :value => "This is my value" )
  end

  let( :fake_attribute ) do
    mock( RDoc::Constant, :name => "attribute", :rw => 'R' )
  end

  let( :fake_public_instance_method ) do
    mock( RDoc::AnyMethod, :name => "public_instance",  
                           :singleton => false,
                           :visibility => :public )
  end

  let( :fake_protected_instance_method ) do
    mock( RDoc::AnyMethod, :name => "protected_instance",  
                           :singleton => false,
                           :visibility => :protected )
  end

  let( :fake_private_instance_method ) do
    mock( RDoc::AnyMethod, :name => "private_instance",  
                           :singleton => false,
                           :visibility => :private )
  end

  let( :fake_public_class_method ) do
    mock( RDoc::AnyMethod, :name => "public_class",  
                           :singleton => true,
                           :visibility => :public )
  end

  let( :fake_protected_class_method ) do
    mock( RDoc::AnyMethod, :name => "protected_class",  
                           :singleton => true,
                           :visibility => :protected )
  end

  let( :fake_private_class_method ) do
    mock( RDoc::AnyMethod, :name => "private_class",  
                           :singleton => true,
                           :visibility => :private )
  end

  let( :rdoc_class ) { mock( RDoc::NormalClass, :type => "module",
                                                :name => "MyModule",
                                                :comment => fake_description,
                                                :includes => [ fake_include ],
                                                :constants => [ fake_constant ],
                                                :attributes => [ fake_attribute ],
                                                :method_list => [ fake_public_instance_method,
                                                                  fake_protected_instance_method,
                                                                  fake_private_instance_method,
                                                                  fake_public_class_method,
                                                                  fake_protected_class_method,
                                                                  fake_private_class_method ]
                                                )
                                                }

  describe "#initialize" do
    context "a class with everything" do
      subject { Bri::Match::Class.new( rdoc_class ) }

      its( :type ) { should == rdoc_class.type }
      its( :name ) { should == rdoc_class.name }
      its( :description_paragraphs ) { should == fake_description.parts.collect { |p| p.parts.join( " " ) } }
      its( :includes ) { should == rdoc_class.includes.collect{ |i| i.full_name } }
      its( :constants ) { should == rdoc_class.constants.collect { |c| { :name => c.name, :value => c.value } } }
      its( :attributes ) { should == rdoc_class.attributes.collect { |a| "#{a.name} (#{a.rw})" } }
      its( :instance_methods ) { should == rdoc_class.method_list.select { |m| m.visibility == :public && m.singleton == false }.collect { |m| m.name } }
      its( :class_methods ) { should == rdoc_class.method_list.select { |m| m.visibility == :public && m.singleton == true }.collect { |m| m.name } }
    end
  end
end
