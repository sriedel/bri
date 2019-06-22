
require 'spec_helper'

describe Bri::Renderer::List::Bullet, type: :renderer do
  describe "bulleted lists with *" do
    subject { render_description_for_method( "bulleted_list" ) }
    it "should indent the list with one space" do
      subject.should include("\n *  First item in a bulleted list")
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should include("*  First item in a bulleted list")
      subject.should include("*  Second item in a bulleted list")
      subject.should include("*  Ending a bulleted list")
    end

    it "should wrap long lines" do
      subject.should include("\n *  Ending a bulleted list with a really really really really really \n    really really really long line that needs to be wrapped\n")
    end

    it "should start second lines of a list item with the same left alignment as the first list items content" do
      subject.should =~ %r{\n \*  First item in a bulleted list(?:\s*?)\n    With a second line\n}
    end

    context "contained verbatim text" do
      subject { render_description_for_method( "list_containing_verbatim_text" ) }
      
      it "should correctly display verbatim text" do
        subject.should include("\n    Containing verbatim text\n")
      end
    end

    context "a nested bulleted list" do
      it "should indent the second level with five spaces" do
        subject.should include("\n     *  First item of a nested bulleted list")
        subject.should include("\n     *  Second item of a nested bulleted list")
      end
    end

    context "a nested numbered list" do
      subject { render_description_for_method( "mixed_list" ) }
      it "should indent the second level with four spaces" do
        subject.should =~ %r{\n    \d\.  And numbers in a sublist\n}
      end
    end
  end

  describe "bulleted lists with -" do
    subject { render_description_for_method "second_bulleted_list" }
    it "should indent the list with one space" do
      subject.should include("\n *  A second bulleted list")
    end

    it "should prefix each list item with a '*' bullet" do
      subject.should include("*  A second bulleted list")
      subject.should include("*  Second item in second bulleted list")
      subject.should include("*  Ending the second bulleted list")
    end

    it "should indent the second level with four spaces" do
      subject.should include("\n     *  Nested bulleted list")
      subject.should include("\n     *  Second nested bulleted list item")
    end
  end
end
