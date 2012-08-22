class Kekomi

  class ContentTypes
    
    def self.base
      @_base
    end

    def self.base=(base)
      @_base = base
    end

    def self.add(name, &block)
      name = name.to_s.classify
      if Object.const_defined? name
        return name.constantize
      end
      klass = @_base.nil? ? Class.new : Class.new(@_base)
      Object.const_set name, klass
      [Mongoid::Document, Mongoid::Timestamps, Kekomi::ContentTypes::Base].each do |inc|
        klass.send :include, inc
      end
      klass.class_eval &block
      klass.before_save :serialize_fields
      klass.validates_presence_of klass.represented_with unless klass.represented_with.nil?
      Store.instance.content_types << klass
      klass
    end

    def self.add_without_base(name, &block)
      old_base = @_base
      @_base   = nil
      klass    = self.add(name, &block)
      @_base   = old_base
      klass
    end

  end

end