require 'rdoc/ri/paths'
require 'rdoc/ri/store'
require 'singleton'

module Bri
  class Mall
    include Singleton

    attr_reader :stores

    def classes
      stores.flat_map(&:module_names).uniq.sort
    end

    def class_methods
      stores.each_with_object( [] ) do |store, result|
        store.class_methods.each do |klass, methods|
          methods.each { |method| result << "#{klass}.#{method}" }
        end
      end.uniq
    end

    def instance_methods
      stores.each_with_object( [] ) do |store, result|
        store.instance_methods.each do |klass, methods|
          methods.each { |method| result << "#{klass}##{method}" }
        end
      end.uniq
    end

    private
    def initialize
      # We want: system, site, home and gem documentation
      @stores = RDoc::RI::Paths.each( true, true, true, true ).each_with_object( [] ) do |(path, type), stores|
                  stores << RDoc::Store.new( path, type ).tap { |store| store.load_cache }
                end
    end
  end
end
