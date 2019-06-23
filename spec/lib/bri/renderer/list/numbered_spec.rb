require 'spec_helper'

describe Bri::Renderer::List::Numbered, type: :renderer do
  subject { render_description_for_method "numbered_list" }

  it "should prefix each list item with an indent and a consecutive number" do
    subject.lines.should include("  1. First numbered list item\n")
    subject.lines.should include("  2. Second numbered list\n")
    subject.lines.should include("  3. Ending the main numbered list item\n")
  end

  context "nested numbered lists" do
    it "should indent the second level with five spaces" do
      subject.should =~ %r{\n     \d\. Nested numbered list item}
      subject.should =~ %r{\n     \d\. Second nested numbered list item}
    end

    it "should restart the numbering for nested lists" do
      subject.lines.should include("     1. Nested numbered list item\n")
      subject.lines.should include("     2. Second nested numbered list item\n")
    end
  end

  context "nested bulleted lists" do
    subject { render_description_for_method "second_mixed_list" }

    it "should indent the second level with five spaces" do
      subject.lines.should include("     * Nested bulleted list\n")
    end
  end
end
