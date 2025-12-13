def calc_vert_cols(data, ops)
	# initialize results with last line of numbers
	r = data[0].split(' ').map { |x| x.to_i }
	puts "data[0]: #{r}" if r.length < 50

	data[1..].each.with_index do |line,idx|
		puts "data[#{idx+1}]: #{line}" if data[0].length < 50
		
		  # split the next line of strings into numbers
		  nums = line.split(' ').map {|x| x.to_i}
		  # add or multiply each number into the result array
		  nums.each.with_index { |_,i| r[i] = ops[i] == '+' ? (r[i] + nums[i]) : (r[i] * nums[i]) }
	end
	
	# add up all the problem results and return the sum
	return r.inject(&:+)
end

fn = "input06-sample.txt"
#fn = "input06.txt"

# read the math problems
input = File.read(fn).split("\n").reject(&:empty?)
puts "#{input.length} lines read"

logit = input.length < 50

operators = input.last.split
puts "operators: #{operators}"
input = input[0..-2]
puts "input data: #{input}" if logit

puts "Part 1: The total is #{calc_vert_cols(input, operators)}"
puts


# part 2
vert_probs = []
line_len = input[0].length # each line is the same length

# part 2 goes from right-to-left
input.each.with_index { |line,n| input[n] = line.reverse }
operators = operators.reverse

num_digits = input.length  # max number of digits in each number is the number of data rows
num_probs = operators.length  # number of problems
curr_prob = 0
total = 0
num_str = []

# outer loop: each digit in one row
(0..line_len).select do |x|
  # inner loop: add up each digit vertically in each row to make the full number
  num_str.clear
  (0..(num_digits-1)).select { |n| num_str.push(input[n][x]) if input[n][x] != " " }
  curr_num = num_str.join.to_i
  vert_probs.push(curr_num) unless curr_num == 0
  
  if curr_num == 0
    puts "stacked numbers: #{vert_probs}; #{operators[curr_prob]}" if logit
    total += operators[curr_prob] == '+' ? vert_probs.inject(&:+) : vert_probs.inject(&:*)
    curr_prob += 1
    vert_probs.clear
  end  
end

puts "Part 2: total of vertical numbers is: #{total}"
