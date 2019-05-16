class Selector
  attr_accessor :identifier
  attr_accessor :view_class
  attr_accessor :class_names
  attr_accessor :properties

  ID_PATTERN = /#([a-zA-Z0-9_-]*)/
  VIEW_CLASS_PATTERN = /^([a-zA-Z0-9_-]+)[\.#\[]?/
  CLASS_NAME_PATTERN = /\.([a-zA-Z0-9_-]*)/
  PROPERTY_PATTERN = /\[([a-zA-Z0-9_-]+\=[a-zA-Z0-9\._-]+)\]/

  def initialize(sel_str)
    raise "Please provide a string" unless sel_str.is_a?(String)

    property_matches = sel_str.scan(PROPERTY_PATTERN).flatten

    self.properties = {}
    property_matches.each do |prop_match|
      key, value = prop_match.split('=')
      if value.downcase == 'true'
        self.properties[key] = true
      elsif value.downcase == 'false'
        self.properties[key] = false
      elsif value.to_i(10).to_s == value
        self.properties[key] = value.to_i
      elsif value.to_f.to_s == value
        self.properties[key] = value.to_f
      else
       self.properties[key] = value
      end
    end

    sel_str = sel_str.gsub(PROPERTY_PATTERN, '')

    self.view_class = sel_str.scan(VIEW_CLASS_PATTERN).flatten[0]

    id_matches = sel_str.scan(ID_PATTERN).flatten

    if id_matches.length > 0
      raise "Multiple identifiers in selector" if id_matches.length > 1
      self.identifier = id_matches[0]
    end

    self.class_names = sel_str.scan(CLASS_NAME_PATTERN).flatten
  end

  def matches?(node)
    if self.identifier
      return false unless self.identifier == node.identifier
    end

    if self.view_class
      return false unless self.view_class == node.view_class
    end

    self.class_names.each do |class_name|
      return false unless node.class_names.include?(class_name)
    end

    self.properties.each_pair do |key, value|
      node_prop = node.properties.fetch(key, nil)
      return false unless node_prop

      if node_prop.is_a?(Array)
        return false unless node_prop.includes?(value)
      else
        return false unless node_prop == value
      end
    end

    return true

  end
end



