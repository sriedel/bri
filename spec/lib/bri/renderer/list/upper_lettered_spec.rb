require 'spec_helper'

describe Bri::Renderer::List::UpperLettered, type: :renderer do
  subject { render_description_for_method "upper_lettered_list" }

  it "should prefix each list item with an indent and a consecutive letter" do
    subject.lines.should include("  A. Some goes for lettered lists\n")
    subject.lines.should include("  B. Second item in a lettered list\n")
    subject.lines.should include("  C. Ending the main lettered list item.\n")
  end

  context "nested lettered lists" do
    it "should indent the second level with four spaces" do
      subject.should =~ %r{\n     [A-Z]\. And a nested lettered list item}
    end

    it "should restart the lettering for nested lists" do
      subject.lines.should include("     A. And a nested lettered list item\n")
      subject.lines.should include("     B. Second nested lettered list item\n")
    end
  end
end
