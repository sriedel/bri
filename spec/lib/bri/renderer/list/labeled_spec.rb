require 'spec_helper'

describe Bri::Renderer::List::Labeled, type: :renderer do
  subject { render_description_for_method "labeled_list" }

  it "should prefix each list item with an indent and its note" do
    subject.lines.should include("  First: And this is the list item body\n")
    subject.lines.should include("  Second: Another labled list item\n")
  end
end
