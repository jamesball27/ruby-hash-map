class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def remove
    self.prev.next = self.next
    self.next.prev = self.prev
    self.next = nil
    self.prev = nil
    self
  end
end

class LinkedList
  include Enumerable

  def initialize
    @head = Link.new
    @tail = Link.new

    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head.next
  end

  def last
    @tail.prev
  end

  def empty?
    first == @tail && last == @head
  end

  def get(key)
    link = find_link(key)
    return nil if link.nil?
    link.val
  end

  def include?(key)
    !!find_link(key)
  end

  def append(key, val)
    link = Link.new(key, val)
    link.next = @tail
    link.prev = last
    last.next = link
    @tail.prev = link
  end

  def update(key, val)
    link = find_link(key)
    return nil if link.nil?
    link.val = val
    link
  end

  def remove(key)
    link = find_link(key)
    return nil if link.nil?
    link.remove
  end

  def find_link(key)
    find { |link| link.key == key }
  end

  def each
    current_link = first
    until current_link == @tail
      yield current_link
      current_link = current_link.next
    end
  end
end
