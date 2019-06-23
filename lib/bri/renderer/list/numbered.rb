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
          ' 1. '.size
        end
      end
    end
  end
end
