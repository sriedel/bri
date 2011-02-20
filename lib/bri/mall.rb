require 'rdoc/ri/paths'
require 'rdoc/ri/store'
require 'singleton'

module Bri
  class Mall
    include Singleton

    attr_reader :stores

    def classes
      @stores.collect { |store| store.modules }.flatten.uniq.sort
    end

    def class_methods
      Bri::Mall.instance.stores.map do |store|
        store.class_methods.map do |klass, methods|
          methods.map { |method| "#{klass}.#{method}" }
        end
      end.flatten.uniq
    end

    def instance_methods
      Bri::Mall.instance.stores.map do |store|
        store.instance_methods.map do |klass, methods|
          methods.map { |method| "#{klass}##{method}" }
        end
      end.flatten.uniq
    end

    private
    def initialize
      @stores = []

      # We want: system, site, home and gem documentation
      RDoc::RI::Paths.each( true, true, true, true ) do |path, type|
        @stores << RDoc::RI::Store.new( path, type ).
                                   tap { |store| store.load_cache }
      end
    end

  end
end
