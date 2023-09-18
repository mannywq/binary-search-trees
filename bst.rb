class Node
  attr_accessor :data, :left, :right

  include Comparable

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def <=>(other)
    @data <=> other.data
  end
end

class Tree
  attr_accessor :root, :nodes

  def initialize(node = nil)
    @root = node
    @nodes = 0
  end

  def build_tree(array)
    # puts '--- Build tree ---'
    # puts "Array is: #{array.inspect}"
    return nil if array.empty?
    return Node.new(array[0]) if array.length == 1

    mid = (array.length - 1) / 2

    node = Node.new(array[mid])

    @root = node if @root.nil?
    @nodes += 1

    node.left = build_tree(array[0..mid])
    node.right = build_tree(array[mid + 1..])

    node
  end

  def find(value)
    start = @root

    queue = []

    queue.append(start)

    until queue.empty?

      node = queue.shift
      return node if node.data == value

      queue.append(node.left) unless node.left.nil?
      queue.append(node.right) unless node.right.nil?

      # puts "Queue value now is #{queue.length}"

    end

    nil
  end

  def insert(root, value)
    if root.nil?
      puts "Creating new node with value #{value}"
      return Node.new(value)
    end

    if root.data == value
      puts "#{value} exists - returning node"
      return root
    elsif root.data < value
      puts 'Current node is less than value - Looking right'
      root.right = insert(root.right, value)
    else
      puts 'Current node is higher than value - Looking left'
      root.left = insert(root.left, value)
    end

    root
  end

  def print_tree(node = @root, prefix = '', is_left = true)
    return if node.nil?

    print_tree(node.left, "#{prefix}#{is_left ? '│   ' : '    '}", true)
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    print_tree(node.right, "#{prefix}#{is_left ? '    ' : '│   '}", false)
  end
end

arr = Array.new(10) { rand(1..100) }

sorted = arr.uniq.sort

print "Array is: #{sorted.inspect}"

tree = Tree.new

tree.build_tree(sorted)

puts "Root is #{tree.root}"

tree.insert(tree.root, 81)

tree.print_tree
puts tree.find(81).inspect
