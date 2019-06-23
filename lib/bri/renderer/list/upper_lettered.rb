module Bri
  module Renderer
    class List
      class UpperLettered < Base
        def max_bullet_width
          ' A. '.size
        end

        def next_bullet( item, index )
          @current_bullet ||= 'A'
          result = @current_bullet.dup
          @current_bullet.succ!
          result + ". "
        end
      end
    end
  end
end
