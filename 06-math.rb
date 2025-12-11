#fn = "input06-sample.txt"
fn = "input06.txt"

# read the math problems
data = File.read(fn).split("\n")

operators = []
problems = []

data.reverse_each do |line|
  if operators.empty?
    operators = line.split(' ') 
  else
    if problems.empty?
      problems = line.split(' ').map {|x| x.to_i}
    else
      new_nums = line.split(' ').map { |x| x.to_i}
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

puts "operators: #{operators}" if operators.length < 20
puts "There are #{problems.length} math problems with a total of #{problems.inject(&:+)}"
