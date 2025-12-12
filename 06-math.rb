#fn = "input06-sample.txt"
fn = "input06.txt"

# read the math problems
data = File.read(fn).split("\n").reject(&:empty?)
puts "#{data.length} lines read"

operators = []
problems = []

data.reverse_each.with_index do |line,idx|
  puts "data[#{idx}]: #{line}" if data[0].length < 50
  if operators.empty?
    # the operators are the last row
    # so the first row we encounter (going in reverse) are the operators
    operators = line.split(' ')
  else
    if problems.empty?
      problems = line.split(' ').map {|x| x.to_i}
    else
      # part 1 - calculate each problem as each number is encountered
      new_nums = line.split(' ').map {|x| x.to_i}
      for i in 0..(new_nums.length)
        if operators[i] == '+'
          problems[i] += new_nums[i]
        elsif operators[i] == '*'
          problems[i] *= new_nums[i]
        end
      end
    end
  end
end

puts "Part 1: There are #{problems.length} math problems with a total of #{problems.inject(&:+)}"
puts

# part 2
vert_probs = []
line_len = data[0].length # each line is the same length
logit = line_len < 50

# part 2 goes from right-to-left
data.each.with_index do |line,n|
  data[n] = line.reverse
  puts "reversed line [#{n}]: #{data[n]}" if logit
end
operators = operators.reverse

# remove the operators row
data.delete_at(data.length-1) 
puts "operators: #{operators}" if operators.length <

# the max number of digits for each number is the number of data rows
num_digits = data.length 
puts "max number of digits in each number: #{num_digits}"

num_probs = operators.length  # number of problems
curr_prob = 0
total = 0
num_str = []

# outer loop: each digit in one row
(0..(line_len)).select do |x|
  # inner loop: add up each digit vertically in each row to make the full number
  num_str.clear
  (0..(num_digits-1)).select { |n| num_str.push(data[n][x]) if data[n][x] != " " }
  curr_num = num_str.join.to_i
  vert_probs.push(curr_num) unless curr_num == 0
  
  if curr_num == 0
    puts "stacked numbers: #{vert_probs}; current operator: #{operators[curr_prob]}" if logit
    if operators[curr_prob] == '+' 
      tmp_total = vert_probs.inject(&:+)
      puts "these numbers added = #{tmp_total}" if logit
    elsif operators[curr_prob] == '*' 
      tmp_total = vert_probs.inject(&:*)
      puts "these numbers multiplied = #{tmp_total}" if logit
    end        
    curr_prob += 1
    total += tmp_total
    vert_probs.clear
  end  
end

puts "Part 2: total of vertical numbers is: #{total}"

