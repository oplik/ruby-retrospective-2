class Array
  def to_hash
    Hash[*self.flatten(1)]
  end
  def index_by
    inject({}) do |result, current| 
      result[yield(current)] = current
      result
    end
  end
  def subarray_count(substr)
    substr = substr.join if((string = self.join) and substr.is_a?(Array))
    count = 0
    count+=1 while(string.include?(substr) and string.sub!(substr, substr[1..-1]))
    count
  end
  def occurences_count
    h = Hash.new(0)
    inject(h) do |result, current| 
      result[current]+=1
      result
    end
  end
end