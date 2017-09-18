require_relative 'linked_list'
require 'digest'

class HashMap
  include Enumerable

  attr_reader :count

  def initialize(num_buckets = 8)
    @store = Array.new(num_buckets) { LinkedList.new }
    @count = 0
  end

  def include?(key)
    bucket(key).include?(key)
  end

  def set(key, val)
    bucket = bucket(key)
    if bucket.include?(key)
      bucket.update(key, val)
    else
      bucket.append(key, val)
      @count += 1
      resize! if count > num_buckets
    end
    true
  end

  def get(key)
    bucket(key).get(key)
  end

  def delete(key)
    bucket(key).remove(key)
    @count -= 1
  end

  def each
    @store.flatten.each do |bucket|
      bucket.each { |link| yield(link.key, link.val) }
    end
  end

  alias_method :[], :get
  alias_method :[]=, :set

  private

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { LinkedList.new }
    @count = 0
    old_store.flatten.each do |bucket|
      bucket.each { |link| set(link.key, link.val) }
    end
  end

  def bucket(key)_
    digest = Digest::MD5.hexdigest(key.to_s)
    num = digest.to_i(16)
    @store[num % num_buckets]
  end
end
