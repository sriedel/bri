module Bri
  module Renderer
    class List
      class Bullet < Base
        def max_bullet_width
          ' * '.size
        end

        def next_bullet( item )
          '* '
        end
      end
    end
  end
end
