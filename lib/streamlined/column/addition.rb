class Streamlined::Column::Addition < Streamlined::Column::Base
  attr_accessor :name, :sort_column, :enumeration

  def initialize(sym, parent_model)
    @name = sym.to_s
    @human_name = sym.to_s.humanize
    @read_only = true
    @parent_model = parent_model
  end
  
  def addition?
    true
  end

  # Array#== calls this
  def ==(o)
    return true if o.object_id == object_id
    return false unless self.class === o
    return name.eql?(o.name)
  end
  
  def sort_column
    @sort_column.blank? ? name : @sort_column
  end
  
  def render_td_show(view, item)
    render_content(view, item)
  end
  
  def render_td_edit(view, item)
    if !(name  =~ /uploaded_data/).nil?
      result = view.file_field(model_underscore, name, html_options)
    elsif enumeration
      result = render_enumeration_select(view, item)
    else
      result = view.text_field(model_underscore, name, html_options)
    end
    wrap(result)
  end
  alias :render_td_new :render_td_edit
  
  def render_enumeration_select(view, item)
    id = relationship_div_id(name, item)
    choices = enumeration.to_2d_array
    choices.unshift(unassigned_option) if column_can_be_unassigned?(parent_model, name.to_sym)
    args = [model_underscore, name, choices]
    args << {} << html_options unless html_options.empty?
    view.select(*args)
  end
  
  def relationship_div_id(name, item, class_name = '', in_window = false)
    fragment = "temp"
    "#{fragment}::#{name}::#{item.id}::#{class_name}#{'::win' if in_window}"
  end
  
end
