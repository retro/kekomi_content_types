class Kekomi
  class ContentTypes
    module Errors
      
      exceptions = %w[InvalidFieldType DuplicateFieldType]
    
      exceptions.each { |e| const_set(e, Class.new(StandardError)) }  
    
    end
  end
end 