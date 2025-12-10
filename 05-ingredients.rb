class FreshIngredients
  
  attr_accessor :fresh_ranges, :ingredients, :logit

  def initialize
    @fresh_ranges = Array.new
    @ingredients = Array.new
    @fresh_ings = Array.new
    @logit = true
  end

  def find_fresh_ingredients
    @ingredients.each do |ing|
      for r in 0..((@fresh_ranges.length+1)/2-1)
        start = @fresh_ranges[r*2]
        stop = @fresh_ranges[r*2+1]
        if ing >= start && ing <= stop
          @fresh_ings.push(ing)
          puts "found fresh ingredient #{ing} in the range [#{@fresh_ranges[r*2]}..#{@fresh_ranges[r*2+1]}]"
          break
        end
      end
    end

    return @fresh_ings.length
  end


end


#fn = "input05-sample.txt"
fn = "input05.txt"

# read the ranges into this temporary array of strings
range_strs = Array.new

fi = FreshIngredients.new
File.open(fn) do |f|
  reading_ranges = true
  f.each_line(chomp: true) do |line|
    reading_ranges = false if line.length == 0 && reading_ranges

    if reading_ranges && line.length > 0
      # temp list of ranges
      range_strs.push(line)
    elsif !reading_ranges && line.length > 0
      # read the ingredients directly to the class array
      fi.ingredients.push(line.to_i)
    end
  end
end

fi.logit = false if fi.ingredients.length > 20

puts "#{range_strs.length} fresh ranges read; #{fi.ingredients.length} ingredients read."
unless range_strs.empty? || fi.ingredients.empty?
  # convert the range strings to integers and add them to the class array: [start, stop, start, stop, etc.]
  range_strs.each do |rs| 
    rs.split("-") { |r| fi.fresh_ranges.push(r.to_i) }    
  end

  # the class now has all the info it needs
  puts "There are #{fi.find_fresh_ingredients} fresh ingredients."
end