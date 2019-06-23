module Bri
  module Renderer
    class List
      class Numbered < Base
        def next_bullet( item )
          @current_bullet ||= '1'
          result = "#{@current_bullet}. "
          @current_bullet.succ!
          result
        end

        def max_bullet_width
          @max_bullet_width ||= Math.log10( element.items.size ).ceil + 3
        end
      end
    end
  end
end
