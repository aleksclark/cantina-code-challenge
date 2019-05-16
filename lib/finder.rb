require "json"
require_relative "selector"
require_relative "node"

class Finder
  VALIDATOR_PATTERN = /[^a-zA-Z0-9=\ \[\]\.\#_-]/
  attr_accessor :root_node

  def initialize(json_string)
    data = JSON.parse(json_string)
    self.root_node = Node.new(data)
  end

  def find_nodes(selector_string)
    raise "Invalid selector string" if VALIDATOR_PATTERN.match(selector_string)
    selectors = selector_string.split(' ').compact.map {|s| Selector.new(s) }
    candidate_nodes = [self.root_node]
    while selectors.length > 0
      current_selector = selectors.shift
      candidate_nodes = candidate_nodes.map {|n| n.matching_nodes(current_selector)}
      candidate_nodes.flatten!
    end

    return candidate_nodes
  end
end
