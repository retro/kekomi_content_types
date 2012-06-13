module Kekomi

  class ContentTypes
    
    def self.base
      @_base
    end

    def self.base=(base)
      @_base = base
    end

    def self.add(name, &block)
      name = name.to_s.classify
      klass = @_base.nil? ? Class.new : Class.new(@_base)
      Object.const_set name, klass
      [Mongoid::Document, Mongoid::Timestamps, Kekomi::ContentTypes::Base].each do |inc|
        klass.send :include, inc
      end
      klass.instance_eval &block
      klass
    end

  end

end