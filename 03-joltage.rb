class Batteries
  
  attr_accessor :total_joltage, :logit

  def initialize
    @total_joltage = 0
    @bank_count = 0
    @logit = true
  end

  def activate_bank(b)
    @bank_count += 1
    joltage = 0

    # puts " bank #{@bank_count} has #{b.length} columns"

    for i1 in 0..(b.length-2)
      for i2 in (i1+1)..(b.length-1)
        testjoltage = b[i1].to_i * 10 + b[i2].to_i
        joltage = testjoltage if testjoltage > joltage
        # puts "  b[#{i1},#{i2}] = #{testjoltage}" if @bank_count == 3
      end
    end

    puts "bank #{@bank_count} has #{joltage} jolts"
    @total_joltage += joltage
  end
end

bats = Batteries.new
data = File.read("input03.txt").split("\n")
bats.logit = false if data.length > 20
unless data.empty?
  data.each { |x| bats.activate_bank(x) }
  puts "the total joltage of the activated batteries is: #{ bats.total_joltage }."
end