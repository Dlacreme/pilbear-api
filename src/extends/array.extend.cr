class Array(T)
  def merge(c : String) : String
    merged = ""
    self.each { |x| merged += "#{x.to_s}#{c}" }
    merged.chomp(c)
    merged
  end
end
