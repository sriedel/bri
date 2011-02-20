# This is a class description
class BriDummySpecClassTwo
  include BriDummySpecModule
  extend BriDummySpecModuleTwo
  CONSTANT = 'value'
  OTHER_CONSTANT = nil
  attr_reader :read_attr
  attr_writer :write_attr
  attr_accessor :access_attr

  def self.bri_dummy_spec_second_singleton_method; end
  def bri_dummy_spec_instance_method_with_arguments( a, b ); end
end

class BriDummySpecClassEmpty; end

module BriDummySpecModule; end
module BriDummySpecModuleTwo; end

module BriDummySpec
  class Class; end
end

class BriDummySpecClass
  def self.bri_dummy_spec_singleton_method; end
  def self.bri_dummy_spec_second_singleton_method; end

  def bri_dummy_spec_instance_method; end

  def bri_dummy_spec_instance_method_with_arguments( a, b ); end

  def bri_dummy_spec_instance_method_with_default_arguments( a, b, c = nil ); end

  def bri_dummy_spec_instance_method_which_yields
    yield yield_param_one, yield_param_two
  end

  def bri_dummy_spec_instance_method_with_yield_override # :yields: foo, bar
    yield yield_param_one, yield_param_two
  end


  # = This is a headline
  #
  # Followed by some introduction text.
  def basic_headline_and_paragraph_rendering_test_method; end

  # == This is a level two headline
  # This is a paragraph with a really really really really really really really really really really long line that needs to be wrapped.
  def level_two_headline_and_line_wrapping_rendering_test_method; end

  # This is some text before a horizontal rule.
  # ---
  # After a horizontal rule, the text continues.
  def horizontal_rule_rendering_test_method; end

  # * First item in a bulleted list
  #   With a second line
  # * Second item in a bulleted list
  #   * First item of a nested bulleted list
  #   * Second item of a nested bulleted list
  # * Ending a bulleted list with a really really really really really really really really long line that needs to be wrapped
  def bulleted_list_rendering_test_method; end

  # - A second bulleted list
  # - Second item in second bulleted list
  #   - Nested bulleted list
  #   - Second nested bulleted list item
  # - Ending the second bulleted list
  def second_bulleted_list_rendering_test_method; end

  # 1. First numbered list item
  # 2. Second numbered list
  #    1. Nested numbered list item
  #    2. Second nested numbered list item
  # 3. Ending the main numbered list item
  def numbered_list_rendering_test_method; end

  # a. Some goes for lettered lists
  # b. Second item in a lettered list
  #    a. And a nested lettered list item
  #    c. Second nested lettered list item
  # c. Ending the main lettered list item.
  def lettered_list_rendering_test_method; end

  # * A mixed list, containing
  # * bullets in the main list
  #   1. And numbers in a sublist
  def mixed_list_rendering_test_method; end

  # 1. Also in reverse
  # 2. Second item
  #    * Nested bulleted list
  def second_mixed_list_rendering_test_method; end

  # [First] And this is the list item body
  #         With a second line containing more text
  #
  # [Second] Another labled list item
  def labeled_list_rendering_test_method; end

  # First:: With some text.
  # Secondarily:: Lets see if this lines up.
  def lined_up_labeled_list_rendering_test_method; end

  # * a list item
  #   with a long item text
  #  Containing verbatim text
  def list_containing_verbatim_text_rendering_test_method; end

  # Text with stylings: *bold*, _emphasized_ and +monospaced+. 
  def simple_styling_rendering_test_method; end
  
  # Also with html: <b>Bold</b>, <em>emphasized</em>, <i>also emphasized</i> 
  # and <tt>monospaced tt</tt> or <code>monospaced code</code>. 
  def html_styling_rendering_test_method; end

  # These should not be styled: \<b>Not bold\</b>, \<em>not emphasized\</em>.
  def escaped_styling_rendering_test_method; end

  # Furthermore, this text contains links to raw links http://www.google.com mailto:spamidyspam@spam.com ftp://warez.teuto.de and plain web links: www.test.com .
  #
  # Then we have local links to other files: link:/etc/fstab
  def raw_link_rendering_test_method; end

  # Plus: Labled links SingleWordLabel[http://duckduckgo.com] and {Multi Word Labels}[http://www.github.com].
  def labeled_link_rendering_test_method; end

  # Conversion characters: this: -- or --- should be an em-dash. We also have an ellipsis: ... . Copyright: (c) and registered trademark (r).
  def conversion_character_rendering_test_method; end
end
