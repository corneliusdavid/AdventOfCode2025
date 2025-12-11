class FreshIngredients
  
  attr_accessor :fresh_ranges, :ingredients, :logit

  def initialize
    # array of ranges (each element is an array: [start..stop])
    @fresh_ranges = Array.new
    # all ingredients in the database
    @ingredients = Array.new
    # all the ingredients that are in the fresh ranges
    @fresh_ings = Array.new

    @logit = true
  end

  def find_fresh_ingredients
    @ingredients.each do |ing|
      @fresh_ranges.each do |r|
        if r.cover?(ing) 
          @fresh_ings.push(ing)
          puts "#{ing} is in #{r}" if @logit
          break
        end
      end
    end

    return @fresh_ings.length
  end

  def count_fresh_ids_possible
    fresh_ids = Array.new

    # merge overlapping ranges
    merged = []                             # create a new array for the merged ranges
    sorted = @fresh_ranges.sort_by(&:min)   # create a new array from the fresh ranges sorted
    sorted.each do |range|
      puts "merging #{range}" if @logit
      if merged.empty? || merged.last.max < range.min - 1
        # no overlap (allowing adjacent ranges like 5..6 and 7..8 to merge)
        merged << range
      else
        # overlap detected, extend the previous range
        merged[-1] = merged.last.min..[merged.last.max, range.max].max
      end
    end

    merged.each { |range| puts "range: #{range}" if @logit }
    return merged.sum(&:size)
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
      # each element is an integer array range [start-stop]
      min,max = line.split('-').map(&:to_i)
      fi.fresh_ranges.push(min..max)
    elsif !reading_ranges && line.length > 0
      # read the ingredients directly to the class array
      fi.ingredients.push(line.to_i)
    end
  end
end

fi.logit = false if fi.ingredients.length > 20

puts "#{fi.fresh_ranges.length} fresh ranges read; #{fi.ingredients.length} ingredients read."
unless fi.fresh_ranges.empty? || fi.ingredients.empty?
  puts "There are #{fi.find_fresh_ingredients} fresh ingredients and a possible of #{fi.count_fresh_ids_possible} fresh ingredient IDs."
end