module Bri
  module Renderer
    class List
      class Labeled < Base
        def max_bullet_width
          @max_bullet_width ||= element.items.map(&:label).map(&:size).max
        end

        def next_bullet( item )
          "#{item.label.first}: "
        end
      end
    end
  end
end
