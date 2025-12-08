class Batteries
  
  attr_accessor :total_joltage, :total_12joltage, :logit

  def initialize
    @total_joltage = 0
    @total_12joltage = 0
    @battery_addresses = ''
    @bank_count = 0
    @logit = true
  end

  def activate_2banks(b)
    @bank_count += 1
    joltage = 0

    for i1 in 0..(b.length-2)
      for i2 in (i1+1)..(b.length-1)
        testjoltage = b[i1].to_i * 10 + b[i2].to_i
        joltage = testjoltage if testjoltage > joltage
      end
    end

    puts "bank #{@bank_count} has [02] #{joltage} jolts"
    @total_joltage += joltage
  end

  def activate_12banks(digits_str)
    n = digits_str.length
    max_digits = 12  # digits to select
    max_to_remove = n - max_digits
    
    stack = []
    
    digits_str.each_char.with_index do |digit, i|
      # how many more chars after this one?
      remaining = n - i - 1

      # pop smaller digits if we can still remove more; skips first time
      while !stack.empty? && 
            stack.last < digit && 
            stack.size + remaining >= max_digits
        stack.pop        
      end
      
      stack.push(digit) if stack.size < max_digits
    end
    
    curr_joltage = stack.join.to_i
    puts "bank #{@bank_count} has [12] #{curr_joltage} jolts"
    @total_12joltage += curr_joltage
  end

end

bats = Batteries.new
#data = File.read("input03-input.txt").split("\n")
data = File.read("input03.txt").split("\n")
bats.logit = false if data.length > 20
unless data.empty?
  data.each do |x|
    bats.activate_2banks(x) 
    bats.activate_12banks(x)
  end
  puts "the total joltage of the  2 highest joltage activated batteries is: #{ bats.total_joltage }."
  puts "the total joltage of the 12 highest joltage activated batteries is: #{ bats.total_12joltage }."
end