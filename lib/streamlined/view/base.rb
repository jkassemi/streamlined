class Streamlined::View::Base
  attr_reader :fields
  attr_reader :association
  attr_reader :separator
  attr_reader :fields_to_update
  attr_reader :partial_to_use
  
  class <<self
    attr_accessor :empty_list_content
  end
  @empty_list_content = "No records found"
  
  # When creating a relationship manager, specify the list of fields that will be 
  # rendered at runtime.
  def initialize(options = {})
    @fields           = options[:fields]
    @options          = options
    @partial_to_use   = options[:partial_to_use]
    @fields_to_update = options[:fields_to_update]
    @separator        = options[:separator] || ":"
  end
  
  # Returns the string representation used to create JavaScript IDs for this relationship type.
  # Fragile: might be a problem with modules or anonymous subclasses
  def id_fragment
    return ActiveSupport::Inflector.demodulize(self.class.name)
  end
  
  # Returns the path to the partial that will be used to render this relationship type.
  def partial
    mod = self.class.name.split("::")[-2]
    "../../vendor/plugins/streamlined/templates/relationships/#{mod.underscore}/#{ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self.class.name))}"
    #"/relationships/#{mod.underscore}/#{ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self.class.name))}.rhtml"
  end
  
  def partial_with_underscore
    mod = self.class.name.split("::")[-2]
    "/relationships/#{mod.underscore}/_#{ActiveSupport::Inflector.underscore(ActiveSupport::Inflector.demodulize(self.class.name))}.rhtml"
  end
    
end

