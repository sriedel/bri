module Bri
  module Renderer
    class List
      class UpperLettered < Base
        def max_bullet_width
          @max_bullet_width ||= ( Math.log10( element.items.size ) / Math.log10( 26 ) ).ceil + 3
        end

        def next_bullet( item )
          @current_bullet ||= 'A'
          result = "#{@current_bullet}. "
          @current_bullet.succ!
          result
        end
      end
    end
  end
end
