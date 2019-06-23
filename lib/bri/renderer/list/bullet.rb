module Bri
  module Renderer
    class List
      class Bullet < Base
        def max_bullet_width
          3
        end

        def next_bullet( item )
          '* '
        end
      end
    end
  end
end
