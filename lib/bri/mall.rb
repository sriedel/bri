require 'rdoc/ri/paths'
require 'rdoc/ri/store'

module Bri
  class Mall

    def self.ri_paths( system: true, site: true, home: true, gems: true )
      @ri_paths ||= RDoc::RI::Paths.each( system, site, home, gems )
    end

    def self.stores
      @stores ||= ri_paths.each_with_object( [] ) do |(path, type), stores|
                    stores << RDoc::Store.new( path, type ).tap { |store| store.load_cache }
                  end
    end

    def self.classes
      stores.flat_map(&:module_names).uniq.sort
    end

    def self.class_methods
      stores.each_with_object( [] ) do |store, result|
        store.class_methods.each do |klass, methods|
          methods.each { |method| result << "#{klass}.#{method}" }
        end
      end.uniq
    end

    def self.instance_methods
      stores.each_with_object( [] ) do |store, result|
        store.instance_methods.each do |klass, methods|
          methods.each { |method| result << "#{klass}##{method}" }
        end
      end.uniq
    end
  end
end
