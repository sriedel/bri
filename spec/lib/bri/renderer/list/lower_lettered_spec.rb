require 'spec_helper'

describe Bri::Renderer::List::LowerLettered, type: :renderer do
  subject { render_description_for_method "lower_lettered_list" }

  it "should prefix each list item with and indent and a consecutive letter" do
    subject.lines.should include("  a. Some goes for lettered lists\n")
    subject.lines.should include("  b. Second item in a lettered list\n")
    subject.lines.should include("  c. Ending the main lettered list item.\n")
  end

  context "nested lettered lists" do
    it "should indent the second level with five spaces" do
      subject.should =~ %r{\n     [a-z]\. And a nested lettered list item}
    end

    it "should restart the lettering for nested lists" do
      subject.lines.should include("     a. And a nested lettered list item\n")
      subject.lines.should include("     b. Second nested lettered list item\n")
    end
  end
end
