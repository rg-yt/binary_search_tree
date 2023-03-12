class Node
  include Comparable
  attr_accessor :left, :right, :data

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    array = array.uniq.sort
    @root = build_tree(array)
  end

  def build_tree(array)
    return nil if array.length.zero?

    mid = array.length / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid + 1...])
    root
  end

  def insert(value, root = @root)
    return Node.new(value) if root.nil?

    if value < root.data
      root.left = insert(value, root.left)
    elsif value > root.data
      root.right = insert(value, root.right)
    end
    root
  end

  def delete(value, root = @root)
    return if root.nil?

    if value < root.data
      root.left = delete(value, root.left)
    elsif value > root.data
      root.right = delete(value, root.right)
    else
      if root.left.nil?
        return root.right
      elsif root.right.nil?
        return root.left
      end

      root.data = min_value(root.right)
      root.right = delete(root.data, root.right)
    end
    root
  end

  def min_value(root)
    min_value = root.data

    until root.left.nil?
      min_value = root.left.data
      root = root.left
    end
    min_value
  end

  def find(value)
    node = @root
    node = value < node.data ? node.left : node.right until node.nil? || node.data == value
    node
  end

  def height(root)
    return -1 if root.nil?

    left_height = height(root.left) + 1 
    right_height = height(root.right) + 1
    left_height > right_height ? left_height : right_height
  end

  def depth(node, root = @root)
    dist = -1
    return dist if root.nil?
    return dist + 1 if root == node

    dist_left = depth(node, root.left)
    return dist_left + 1 if dist_left >= 0

    dist_right = depth(node, root.right)
    return dist_right + 1 if dist_right >= 0

    dist
  end

  def level_order
    array = [@root]
    output = []
    until array.empty?
      value = array.shift
      block_given? ? yield(value) : output << value.data
      array << value.left unless value.left.nil?
      array << value.right unless value.right.nil?
    end
    output unless block_given?
  end

  def inorder(root = @root, output = [], &block)
    return if root.nil?

    inorder(root.left, output, &block)
    block_given? ? block.call(root.data) : output << root.data
    inorder(root.right, output, &block)
    output unless block_given?
  end

  def preorder(root = @root, output = [], &block)
    return if root.nil?

    block_given? ? block.call(root.data) : output << root.data
    preorder(root.left, output, &block)
    preorder(root.right, output, &block)
    output unless block_given?
  end

  def postorder(root = @root, output = [], &block)
    return if root.nil?

    postorder(root.left, output, &block)
    postorder(root.right, output, &block)
    block_given? ? block.call(root.data) : output << root.data
    output unless block_given?
  end
  
  def balanced?(root = @root)
    return true if root.nil?

    left = height(root.left)
    right = height(root.right)

    ans = left > right ? left - right : right - left

    return false if ans > 1 || ans < -1

    balanced?(root.left)
    balanced?(root.right)

  end

  def rebalance
    @root = build_tree(inorder)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.pretty_print
p tree.balanced?
p tree.level_order
p tree.postorder
p tree.preorder
p tree.inorder
tree.insert(120)
tree.insert(140)
tree.insert(160)
tree.insert(180)
tree.insert(200)
tree.pretty_print
p tree.balanced?
tree.rebalance
p tree.balanced?
tree.pretty_print
p tree.level_order
p tree.postorder
p tree.preorder
p tree.inorder