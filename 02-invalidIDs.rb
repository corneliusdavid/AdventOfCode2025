class InvalidIDs
  
  attr_accessor :invalid_other_total, :invalid_half_total, :invalid_other_count, :invalid_half_count, :logit

  def initialize
    @invalid_half_total = 0
    @invalid_half_count = 0
    @invalid_other_total = 0
    @invalid_other_count = 0
    @invalid_list = []
    @logit = true
  end

  def add_invalid(id, type)
    return false if @invalid_list.include?(id)
    @invalid_list.push(id)
    val = id.to_i
    
    if type == :half
      @invalid_half_total += val
      @invalid_half_count += 1
      puts "  #{id}: half match. invalids (half) found: #{@invalid_half_count}" if @logit
    else
      @invalid_other_total += val
      @invalid_other_count += 1
      puts "  #{id}: #{type}; #{@invalid_other_count}" if @logit
    end
    true
  end

  def check_id_half(id)
    # flag ids that have two duplicate halfs
    if id.length.even?
      half_len = id.length / 2
      add_invalid(id, :half) if id[0, half_len] == id[half_len, half_len]
    end
  end

  def check_id_allsame(id)
    # flag ids where all digits are the same
    add_invalid(id, "all same digits") if id.chars.uniq.size == 1
  end 

  def check_id_other(id)
    # flag ids that have multiple matching chunks
    patterns = { 6 => 2, 8 => 2, 9 => 3, 10 => 2 }
    if chunk_size = patterns[id.length]
      chunks = id.scan(/.{#{chunk_size}}/)
      add_invalid(id, "other id match") if chunks.uniq.size == 1
    end
  end

  def check_all_patterns(id)
    check_id_half(id)
    check_id_allsame(id)
    check_id_other(id)
  end

  def check_range(id_range)
    # split the id range into two numbers
    start, stop = id_range.split('-').map(&:to_i)
    puts "#{id_range}: [#{start}..#{stop}]" if @logit

    # check all the ids in the range
    (start..stop).each { |i| check_all_patterns(i.to_s)}
  end
end

invalids = InvalidIDs.new
#data = File.read("input02-sample.txt").split(",")
data = File.read("input02.txt").split(",")
invalids.logit = data.length <= 20

data.each { |x| invalids.check_range(x) }
puts "the total of the invalid (half) IDs is: #{ invalids.invalid_half_total }."
puts "the total of the invalid (all) IDs is: #{ invalids.invalid_other_total + invalids.invalid_half_total }."
