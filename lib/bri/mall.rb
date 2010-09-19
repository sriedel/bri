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

    private
    def initialize
      @stores = []

      # We want: system, site, home and gem documentation
      RDoc::RI::Paths.each( true, true, true, true ) do |path, type|
        @stores << RDoc::RI::Store.new( path, type ).tap { |store| store.load_cache }
      end
    end

  end
end
