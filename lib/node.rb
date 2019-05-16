class Node
  attr_accessor :identifier
  attr_accessor :view_class
  attr_accessor :class_names
  attr_accessor :properties
  attr_accessor :children
  attr_accessor :raw

  def initialize(data)
    unless data.is_a?(Hash)
      throw "Please provide a hash"
    end

    self.raw = data.clone

    self.identifier = data.delete("identifier")
    self.view_class = data.delete("class")
    self.class_names = data.delete("classNames") {|k| [] }

    self.properties = {}
    self.children = []

    data.each_pair do |k,v|
      if v.is_a?(Hash)
        child = Node.new(v)
        self.children.push(child)
        self.properties[k] = child
      elsif v.is_a?(Array)
        if v[0] && v[0].is_a?(Hash)
          child_array = []
          v.each do |child_data|
            child = Node.new(child_data)
            child_array.push(child)
            self.children.push(child)
          end
          self.properties[k] = child_array
        else
          # assuming a well-formed data structure here for the sake of efficiency,
          # so arrays either contain objects, or values, not a mix
          self.properties[k] = v
        end

      else
        self.properties[k] = v
      end
    end
  end

  def matching_nodes(selector)
    matches = self.children.map {|c| c.matching_nodes(selector) }
    matches.push(self) if selector.matches?(self)
    return matches.flatten.compact
  end

end


