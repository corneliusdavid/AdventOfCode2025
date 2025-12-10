class DialPassword

  attr_accessor :zero_count, :zero_passive, :logit
    
    def initialize
      @zero_count = 0
      @zero_passive = 0
      @curr_pos = 50
      @DIAL_MAX = 99
      @logit = true
    end

 def rotate(amount)
    @curr_pos += (@DIAL_MAX + 1) if amount < 0 && @curr_pos == 0  # Special case for left rotation from 0
    @curr_pos += amount
    
    while @curr_pos < 0 || @curr_pos > @DIAL_MAX
      if @curr_pos < 0
        @zero_passive += 1
        @curr_pos += (@DIAL_MAX + 1)
      else
        @zero_passive += 1 if @curr_pos > (@DIAL_MAX + 1)
        @curr_pos -= (@DIAL_MAX + 1)
      end
    end
    
    @zero_count += 1 if @curr_pos == 0
    direction = amount > 0 ? 'right' : 'left'
    puts "rotate #{direction} #{amount.abs}: #{@curr_pos} (ZeroCount: #{@zero_count}, ZeroPassive: #{@zero_passive})" if @logit
  end

end

dp = DialPassword.new
data = File.read("input01.txt").split("\n")
dp.logit = data.length <= 100

data.each do |elem| 
  amount = elem[1..].to_i
  dp.rotate(elem[0] == 'L' ? -amount : amount)
end
puts "Number of zero positions encountered: directly = #{dp.zero_count}, passively = #{dp.zero_passive}; total = #{dp.zero_count + dp.zero_passive}"
