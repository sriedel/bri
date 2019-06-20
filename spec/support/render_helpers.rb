module RenderHelpers
  def render_description_for_method( method_name )
    search_instance = Bri::Search::InstanceMethod.new( "BriDummySpecClass##{method_name}_rendering_test_method" ) 
    search_instance.search( :fully_qualified )
    search_instance.matches.first.to_s
  end
end
