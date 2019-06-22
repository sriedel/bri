require 'spec_helper'

describe Bri::Renderer::List::Numbered, type: :renderer do
  subject { render_description_for_method "numbered_list" }

  it "should not indent the list items" do
    subject.should =~ %r{\n\d\.  First numbered list item}
  end

  it "should prefix each list item with a consecutive number" do
    subject.should include("1.  First numbered list item")
    subject.should include("2.  Second numbered list")
    subject.should include("3.  Ending the main numbered list item")
  end

  context "nested numbered lists" do
    it "should indent the second level with four spaces" do
      subject.should =~ %r{\n    \d\.  Nested numbered list item}
      subject.should =~ %r{\n    \d\.  Second nested numbered list item}
    end

    it "should restart the numbering for nested lists" do
      subject.should include("1.  Nested numbered list item")
      subject.should include("2.  Second nested numbered list item")
    end
  end

  context "nested bulleted lists" do
    subject { render_description_for_method "second_mixed_list" }
    it "should indent the second level with five spaces" do
      subject.should include("\n     *  Nested bulleted list")
    end

    it "should prefix each nested list item with a '*' bullet" do
      subject.should include("*  Nested bulleted list")
    end
  end
end
