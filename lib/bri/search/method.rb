module Bri
  module Search
    class Method < Base
      attr_reader :class_term, :method_term

      def initialize( term )
        super
        @class_term, @method_term = term.split( /[\.#]/, 2 )

        if @class_term !~ /^[A-Z]/ && !@method_term
          @method_term, @class_term = @class_term, @method_term
        end

        @class_term = nil if @class_term&.empty?
      end

      def search( type = :fully_qualified )
        case type
          when :fully_qualified     then fully_qualified_search
          when :partially_qualified then partially_qualified_search
          when :unqualified         then unqualified_search
          else :error # TODO: Error handling
        end
      end

      private
      def fully_qualified_search
        store = store_for_method
        
        @matches << Bri::Match::Method.new( method_rdoc( store ), store ) if store
      end

      def store_for_method
        Bri::Mall.instance.stores.detect do |store|
          store_methods( store ).has_key?( @class_term ) &&
          store_methods( store )[@class_term].include?( @method_term )
        end
      end

      def classes_with_method( store, method )
        store_methods( store ).select do |_klass, methods|
                                 methods.include?( method )
                               end.keys
      end

      def candidates_from_method_re( store, method_re )
        store_methods( store ).each_with_object( {} ) do |(klass, methods), candidates|
          matching_methods = methods.grep( method_re )
          next if matching_methods.empty?

          candidates[klass] = matching_methods
        end
      end


      def partially_qualified_search  
        Bri::Mall.instance.stores.each do |store|
          classes_with_method( store, @method_term ).each do |klass|
            match_data = method_rdoc( store, klass, @method_term ) 
            next unless match_data

            @matches << Bri::Match::Method.new( match_data, store )
          end
        end
      end

      def unqualified_search
        [ /^#{Regexp.escape( @method_term )}$/,
          /^#{Regexp.escape( @method_term )}/,
          /#{Regexp.escape( @method_term )}/ ].each do |method_re|
          unqualified_search_worker( method_re )
          break unless @matches.empty?
        end
      end

      def unqualified_search_worker( method_re )
        Bri::Mall.instance.stores.each do |store|
          candidates_from_method_re( store, method_re ).each do |klass, methods|
            methods.each do |method|
              match_data = method_rdoc( store, klass, method )
              next unless match_data

              @matches << Bri::Match::Method.new( match_data, store )
            end
          end
        end
      end
    end
  end
end
