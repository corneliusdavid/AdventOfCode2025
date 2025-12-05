class DialPassword

  attr_accessor :zero_count, :zero_passive
    
    def initialize
      @zero_count = 0
      @zero_passive = 0
      @curr_pos = 50
      @DIAL_MAX = 99
    end

  def check_zero_count
    if @curr_pos == 0
      @zero_count += 1
      puts "ZERO FOUND!"
    end
  end

  def rotate_left(amount)
    @curr_pos += @DIAL_MAX + 1 if @curr_pos == 0
    @curr_pos -= amount
    while @curr_pos < 0 do      
      @zero_passive += 1 if @curr_pos < 0
      @curr_pos += @DIAL_MAX + 1
    end
    puts "rotate left #{amount}: #{@curr_pos} (ZeroCount: #{@zero_count}, ZeroPassive: #{@zero_passive})"   
    check_zero_count
  end

  def rotate_right(amount)
    @curr_pos += amount
    while @curr_pos > @DIAL_MAX do      
      @zero_passive += 1 if @curr_pos > (@DIAL_MAX + 1)
      @curr_pos -= @DIAL_MAX + 1
    end
    puts "rotate right #{amount}: #{@curr_pos} (ZeroCount: #{@zero_count}, ZeroPassive: #{@zero_passive})"
    check_zero_count
  end

end

dp = DialPassword.new
data = File.read("input01.txt").split("\n")
puts "No data." if data.empty?
data.each do |elem| 
  if elem[0] == 'L'
    dp.rotate_left(elem[1,5].to_i)
  elsif elem[0] == 'R'
    dp.rotate_right(elem[1,5].to_i)
  end
end
puts "Number of zero positions encountered: directly = #{dp.zero_count}, passively = #{dp.zero_passive}; total = #{dp.zero_count + dp.zero_passive}"

# day one = 1092
# day two: 5076 is too low, 7683 is too high

# 50 + 94 = 144; 144 - 99 = 45 (1)
# 45 + 288 = 333; 333 - 99 = 234 (1); 234 - 99 = 135 (1); 135 - 99 = 36