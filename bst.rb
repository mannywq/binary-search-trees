# frozen_string_literal: true

require 'debug'

class Node
  attr_accessor :data, :left, :right

  include Comparable

  def initialize(value = 0)
    @data = value
    @left = nil
    @right = nil
  end

  def <=>(other)
    @data <=> other.data
  end
end

class Tree
  attr_accessor :root, :nodes

  def initialize
    @root = nil
    @nodes = 0
    @parent = nil
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array[0]) if array.length < 2

    # puts array
    mid = (array.length / 2)
    node = Node.new(array[mid])
    @root = node if @root.nil?

    node.left = build_tree(array[0..mid - 1])
    node.right = build_tree(array[mid + 1..])

    node
  end

  def find(node, value)
    return nil if node.nil?
    return node if node.data == value

    if value < node.data
      find(node.left, value)
    else
      find(node.right, value)
    end
  end

  def insert(root, value)
    return Node.new(value) if root.nil?

    if root.data == value
      puts "#{value} exists - returning node"
      return root
    elsif root.data < value
      root.right = insert(root.right, value)
    else
      root.left = insert(root.left, value)
    end
    root
  end

  def delete(node, value)
    return node if node.nil? # Node not found

    res = find(node, value)
    if res.nil?
      puts "Value #{value} not found in tree"
      return node
    end

    puts "Found node at #{res}"

    # Check for no children
    if res.left.nil? && res.right.nil?
      puts 'No children found for node'
      parent = find_parent(res)
      delete_leaf_node(parent, res)

    # Check for one child
    elsif res.left.nil? || res.right.nil?
      puts 'Single child exists - swapping values and deleting'
      parent = find_parent(res)
      delete_single_child(parent, res)
    # Check for two children
    else
      puts 'Node has two children - looking for min successor'

      replacement = find_min(res.right)

      parent = find_parent(replacement)

      res.data = replacement.data

      replacement < parent ? parent.left = nil : parent.right = nil

    end
  end

  def find_parent(node, root = @root)
    return nil if root == node
    return root if root.left == node || root.right == node

    root > node ? find_parent(node, root.left) : find_parent(node, root.right)
  end

  def delete_leaf_node(parent, value)
    parent > value ? parent.left = nil : parent.right = nil
  end

  def delete_single_child(parent, node)
    target = node.right || node.left
    target > parent ? parent.right = target : parent.left = target
  end

  def find_min(node)
    node = node.left until node.left.nil?
    puts "Minimum of right tree is #{node.inspect}"
    node
  end

  def in_order(node = @root, &block)
    return if node.nil?

    in_order(node.left, &block) if node.left
    yield(node) if block_given?
    in_order(node.right, &block) if node.right
  end

  def pre_order(node = @root, &block)
    return if node.nil?

    yield(node) if block_given?
    pre_order(node.left, &block) if node.left
    pre_order(node.right, &block) if node.right
  end

  def post_order(node = @root, &block)
    return if node.nil?

    post_order(node.left, &block) if node.left
    post_order(node.right, &block) if node.right

    yield(node) if block_given?
  end

  def print_tree(node = @root, prefix = '', is_left = true)
    return if node.nil?

    print_tree(node.left, "#{prefix}#{is_left ? '│   ' : '    '}", true) if node.left
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    print_tree(node.right, "#{prefix}#{is_left ? '    ' : '│   '}", false) if node.right
  end

  def level_order(node = @root)
    queue = []
    result = []

    queue << node

    until queue.empty?

      current = queue.shift
      # puts current.data
      result << if block_given?
                  yield(current)
                else
                  current
                end
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    result
  end
end

arr = Array.new(20) { rand(1..40) }

sorted = arr.uniq.sort

tree = Tree.new

tree.build_tree(sorted)

puts tree.find(tree.root, sorted[6]).inspect
tree.delete(tree.root, sorted[6])

arr = []
puts 'Level order traversal with block'
tree.level_order do |node|
  puts "Node: #{node.data}"
  arr << node
end

puts 'Pre order traversal with block'
tree.pre_order { |node| puts "Node: #{node.data}" }

puts 'In order traversal with block'
tree.in_order { |node| puts "Node: #{node.data}" }

puts 'Post order traversal with block'
tree.post_order { |node| puts "Node: #{node.data}" }

# puts arr.length
