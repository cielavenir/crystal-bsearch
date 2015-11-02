struct Range(B, E)
  #Perform binary search
  #Based on Marc-André Lafortune's Ruby backports implementation, ported by @cielavenir

  def bsearch
    #return to_enum(:bsearch) unless block_given?
    from = self.begin
    to   = self.end
    unless from.is_a?(Int) && to.is_a?(Int)
      # Float support is currently dropped
      raise "can't do binary search for #{from.class}"
    end

    midpoint = 0 # placeholder
    #convert = ->{ (pointerof(midpoint) as Pointer(Int64)).value }
    convert = ->{ midpoint }

    to -= 1 if excludes_end?
    satisfied = nil
    while from <= to
      midpoint = (from + to)/2
      result = yield(cur = convert.call)
      case result
      when Int
        return cur if result == 0
        result = result < 0
      when Float
        return cur if result == 0
        result = result < 0
      when true
        satisfied = cur
      when nil, false
        # nothing to do
      else
        raise "wrong argument type #{result.class} (must be numeric, true, false or nil)"
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
  def bsearch
    idx=(0...self.size).bsearch{|i|yield self[i]}
    idx ? self[idx] : nil
  end
  def bsearch_index
    (0...self.size).bsearch{|i|yield self[i]}
  end
end
