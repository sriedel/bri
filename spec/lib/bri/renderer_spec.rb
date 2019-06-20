require 'spec_helper'

describe Bri::Renderer, type: :renderer do
  describe "text stylings" do
    context "for bold text" do
      it "should mark *bold* text with an ANSI bold code" do
        text = render_description_for_method( "simple_styling" )
        text.should =~ %r{#{bold}bold#{reset},}
      end

      it "should mark <b>bold</b> text with an ANSI bold code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ %r{#{bold}Bold#{reset},}
      end

      it "should not mark escaped \<b>bold\</b> text" do
        text = render_description_for_method( "escaped_styling" )
        text.should =~ %r{<b>Not bold<\/b>,}
      end
    end

    context "for emphasized text" do
      it "should mark _emphasized_ text with an ANSI yellow code" do
        text = render_description_for_method( "simple_styling" )
        text.should =~ %r{, #{yellow}emphasized#{reset} and}
      end

      it "should mark <em>emphasized</em> text with an ANSI yellow code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ %r{, #{yellow}emphasized#{reset},}
      end

      it "should mark <i>emphasized</i> text with an ANSI yellow code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ %r{, #{yellow}also emphasized#{reset}}
      end

      it "should not mark escaped \<em>emphasized\</em> text" do
        text = render_description_for_method( "escaped_styling" )
        text.should =~ %r{<em>not emphasized<\/em>}
      end
    end

    context "for code" do
      it "should mark +code+ with an ANSI cyan code" do
        text = render_description_for_method( "simple_styling" ) 
        text.should =~ %r{and #{cyan}monospaced#{reset}}
      end

      it "should mark <tt>code</tt> with an ANSI cyan code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ %r{#{cyan}monospaced tt#{reset}}
      end

      it "should mark <code>code</code> with an ANSI cyan code" do
        text = render_description_for_method( "html_styling" )
        text.should =~ %r{#{cyan}monospaced code#{reset}}
      end
    end
  end

  describe "links" do
    context "raw links" do
      subject { render_description_for_method "raw_link" }

      it "should underline raw http links" do
        subject.should =~ %r{#{underline}http://www.google.com#{reset}}
      end

      it "should underline raw mailto links" do
        subject.should =~ %r{#{underline}mailto:spamidyspam@spam.com#{reset}}
      end

      it "should underline raw ftp links" do
        subject.should =~ %r{#{underline}ftp://warez.teuto.de#{reset}}
      end

      it "should underline plain www links" do
        subject.should =~ %r{#{underline}www.test.com#{reset}}
      end

      it "should underline local file links" do
        subject.should =~ %r{#{underline}/etc/fstab#{reset}}
      end
    end

    context "labeled links" do
      subject { render_description_for_method "labeled_link" }

      context "with single word labels" do
        it "should show the link underlined after the label in brackets" do
          subject.should =~ %r{Labled links SingleWordLabel \(#{underline}http://duckduckgo.com#{reset}\)}
        end
      end

      context "with multi word labels" do
        it "should show the link underlined after the label in brackets and remove the rdoc label curly braces" do
          subject.should =~ %r{Multi\s+Word\s+Labels\s+\(#{underline}http://www.github.com#{reset}\)}m
        end
      end
    end
  end

  describe "conversion characters" do
    subject { render_description_for_method "conversion_character" }

    it "should leave -- as is" do
      subject.should =~ %r{this: -- or}
    end

    it "should leave --- as is" do
      subject.should =~ %r{or --- should}
    end

    it "should leave (c) as is" do
      subject.should =~ %r{Copyright: \(c\)}
    end

    it "should leave (r) as is" do
      subject.should =~ %r{registered trademark \(r\)}
    end
  end


end
