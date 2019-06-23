module Bri
  module Renderer
    class List
      class LowerLettered < Base
        def max_bullet_width
          ' a. '.size
        end

        def next_bullet( item )
          @current_bullet ||= 'a'
          result = "#{@current_bullet}. "
          @current_bullet.succ!
          result
        end
      end
    end
  end
end
