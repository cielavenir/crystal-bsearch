struct Range(B, E)
  # By using binary search, finds a value in range which meets
  # the given condition in O(log n) where n is the size of the range.
  #
  # If x is within the range, this method returns the value x. Otherwise, it returns nil.
  #
  # Based on Marc-André Lafortune's Ruby backports implementation, ported by @cielavenir
  def bsearch(&block : B -> Int|Float|Bool?)
    from = self.begin
    to   = self.end
    unless from.is_a?(Number) && to.is_a?(Number)
      raise "can't do binary search for #{from.class}"
    end

    midpoint = 0 # placeholder
    #convert = ->{ (pointerof(midpoint) as Pointer(Int64)).value }
    convert = ->{ midpoint }

    to -= 1 if excludes_end?
    satisfied = nil
    while from <= to
      midpoint = from + (to - from)/2
      result = yield(cur = convert.call)
      case result
      when Number
        return cur if result == 0
        result = result < 0
      when true
        satisfied = cur
      when nil, false
        # nothing to do
      end

      if result
        to = midpoint - 1
      else
        from = midpoint + 1
      end
    end
    satisfied
  end
end

class Array(T)
  # This method returns the i-th element. If i is equal to ary.size, it returns nil.
  def bsearch(&block : T -> Int|Float|Bool?)
    idx=bsearch_index(&block)
    idx ? self[idx] : nil
  end

  # This method returns the index of the element instead of the element itself.
  def bsearch_index(&block : T -> Int|Float|Bool?)
    (0...self.size).bsearch{|i|yield self[i]}
  end
end
