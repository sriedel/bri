module Bri
  module Renderer
    class List
      class Note < Base
        def max_bullet_width
          element.items.flat_map(&:label).map(&:size).max
        end

        def next_bullet( item )
          "#{item.label.first}:" + " " * (max_bullet_width - item.label.first.size + 1)
        end
      end
    end
  end
end
