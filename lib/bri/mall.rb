require 'rdoc/ri/paths'
require 'rdoc/ri/store'

module Bri
  class Mall
    attr_reader :stores

    def initialize
      @stores = []

      # We want: system, site, home and gem documentation
      RDoc::RI::Paths.each( true, true, true, true ) do |path, type|
        @stores << RDoc::RI::Store.new( path, type ).tap { |store| store.load_cache }
      end
    end

    def classes
      @stores.collect { |store| store.modules }.flatten.uniq.sort
    end

    def class_methods_by_class
      methods = {}
      @stores.each do |store|
        methods.merge!( store.class_methods ) { |key, m1, m2| m1.concat(m2) }
      end
      methods
    end

    def instance_methods_by_class
      methods = {}
      @stores.each do |store|
        methods.merge!( store.instance_methods ) { |key, m1, m2| m1.concat(m2) }
      end
      methods
    end
  end
end
