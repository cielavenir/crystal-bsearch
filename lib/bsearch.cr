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
    if from.is_a?(Int) && to.is_a?(Int)
      convert = -> { midpoint }
    else
      map_Dq = ->(n : Float64) {
        v = n.to_f64.abs
        result = (pointerof(v) as Pointer(Int64)).value
        v<0 ? -result : result
      }
      map_qD = ->(n : Int64) {
        v = n.to_f64.abs
        result = (pointerof(v) as Pointer(Float64)).value
        v<0 ? -result : result
      }
      from = map_Dq.call(from.to_f64)
      to = map_Dq.call(to.to_f64)
      convert = -> { map_qD.call(midpoint.to_i64) }
    end

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
