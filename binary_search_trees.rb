# create Node class
class Node

    attr_accessor :value, :left, :right

    def initialize(value)
        @value = value
        @left = nil
        @right = nil
    end

end


# create Tree class
class Tree

    attr_accessor :root, :data

    def initialize(array)
        @data = array.uniq.sort
        @root = build_tree(data)
    end

    # Turn array into binary search tree
    def build_tree(array)
        if array.empty?
            return nil
        end

        middle = (array.length - 1) / 2
        root_node = Node.new(array[middle])

        root_node.left = build_tree(array[0...middle])
        root_node.right = build_tree(array[(middle + 1)..-1])
        
        root_node
    end

    # accepts a value to insert, return nil if value already exist
    def insert(value, node = root)
        if value == node.value
            return nil
        end
        if value < node.value
            if node.left.nil?
                node.left = Node.new(value)
            else
                insert(value, node.left)
            end
        else
            if node.right.nil?
                node.right = Node.new(value)
            else
                insert(value, node.right)
            end
        end
    end

    # accepts a value to delete
    def delete(value, node = root)
        if node.nil?
            return node
        end
        if value < node.value
            node.left = delete(value, node.left)
        elsif value > node.value
            node.right = delete(value, node.right)
        else
            # if node has one or no child
            return node.right if node.left.nil?
            return node.left if node.right.nil?
            # if node has two children
            mostleftnode = most_left_node(node.right)
            node.value = mostleftnode.value
            node.right = delete(mostleftnode.value, node.right)
        end
        node
    end

    # accepts a value and returns the node with the given value
    def find(value, node = root)
        if node.nil? || node.value == value
            return node
        end
        if value < node.value
            find(value, node.left)
        else
            find(value, node.right)
        end
    end

    # Traversal binary search tree with level order
    def level_order(node = root, queue = [])
        if node.nil?
            return node
        end

        level_order_result = []
        queue << node
        while queue.length > 0
            # print first element of queue and remove it from queue
            level_order_result << queue[0].value

            node = queue.shift
            
            # enqueue left child
            if !node.left.nil?
                queue << node.left
            end
            # enqueue right child
            if !node.right.nil?
                queue << node.right
            end
        end
        level_order_result
    end

    # inorder traversal
    def inorder(node = root)
        if node.nil?
            return node
        end
        if node
            inorder(node.left)
            print "#{node.value} "
            inorder(node.right)
        end
    end

    # preorder traversal
    def preorder(node = root)
        if node.nil?
            return node
        end
        if node
            print "#{node.value} "
            preorder(node.left)
            preorder(node.right)
        end
    end

    # postorder traversal
    def postorder(node = root)
        if node.nil?
            return node
        end
        if node
            postorder(node.left)
            postorder(node.right)
            print "#{node.value} "
        end
    end

    # the number of edges in longest path from a given node to a leaf node.
    def height(value)
        node = find(value)
        if is_leaf?(value)
            return 1
        end
        if node.left.nil?
            return height(node.right.value) + 1
        end
        if node.right.nil?
            return height(node.left.value) + 1
        end
        return [height(node.left.value), height(node.right.value)].min + 1
    end

    # total height of binary search tree
    def tree_height(node = root)
        if node.nil?
            return 0
        end
        return [tree_height(node.left), tree_height(node.right)].max + 1
    end


    # the number of edges in path from a given node to the tree’s root node.
    def depth(value, root_node = root, count = 0)
        node = find(value)
        if value < root_node.value
            count += 1
            depth(value, root_node.left, count)
        elsif value > root_node.value
            count += 1
            depth(value, root_node.right, count)
        else
            count
        end
    end

    # checks if the tree is balanced
    def balanced?(node = root)
        if node.nil?
            return true
        end

        left_height = tree_height(node.left)
        right_height = tree_height(node.right)

        # allowed values for (lh - rh) are 1, -1, 0
        if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)
            return true 
        end
        return false
    end

    # rebalances an unbalanced tree.
    def rebalance
        if balanced?
            return "Binary search tree is balanced."
        else
            self.data = level_order.uniq.sort
            self.root = build_tree(data)
        end
    end

    # print binary search tree
    def pretty_print(node = root, prefix = '', is_left = true)
        pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
        puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
        pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
    end

    # check if node is leaf (no node.left and node.right)
    def is_leaf?(value, node = root)
        if node.nil?
            return node
        end
        if node.value == value
            if node.left.nil? && node.right.nil?
                return true
            else
                return false
            end
        elsif value < node.value
            is_leaf?(value, node.left)
        else
            is_leaf?(value, node.right)
        end
    end

    # find most left node
    def most_left_node(node)
        until node.left.nil?
            node = node.left
        end
        node
    end

end


# driver script
puts "1. "
sample = Array.new(15) { rand(1..100) }
# sample = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
array = Tree.new(sample)
array.pretty_print
p array.balanced?
puts "\n"

puts "2. "
puts "#{array.level_order} <- Level order"
puts "#{array.inorder} <- Inorder"
puts "#{array.preorder} <- Preorder"
puts "#{array.postorder} <- Postorder"
puts "\n"

puts "3. "
rand(1..10).times do
    array.insert(rand(100..1000))
end
array.pretty_print
p array.balanced?
puts "\n"

puts "4. "
array.rebalance
array.pretty_print
p array.balanced?
puts "\n"

puts "5. "
puts "#{array.level_order} <- Level order"
puts "#{array.inorder} <- Inorder"
puts "#{array.preorder} <- Preorder"
puts "#{array.postorder} <- Postorder"
puts "\n"

# array.delete(324)
# p array.height(8)
# p array.depth(67)
# p array.is_leaf?(23)
# p array.is_leaf?(67)
