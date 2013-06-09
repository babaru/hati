class RandomAlphaGenerator
  def self.generate
    Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  end
end
