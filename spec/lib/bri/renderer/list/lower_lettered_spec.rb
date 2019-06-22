require 'spec_helper'

describe Bri::Renderer::List::LowerLettered, type: :renderer do
  subject { render_description_for_method "lower_lettered_list" }

  it "should not indent the list items" do
    subject.should =~ %r{\n.\.  Some goes for lettered lists}
  end

  it "should prefix each list item with a consecutive letter" do
    subject.should include("a.  Some goes for lettered lists")
    subject.should include("b.  Second item in a lettered list")
    subject.should include("c.  Ending the main lettered list item")
  end

  context "nested lettered lists" do
    it "should indent the second level with four spaces" do
      subject.should =~ %r{\n    .\.  And a nested lettered list item}
    end

    it "should restart the lettering for nested lists" do
      subject.should include("a.  And a nested lettered list item")
      subject.should include("b.  Second nested lettered list item")
    end
  end
end
