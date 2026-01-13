class RedTiles

  attr_accessor :data, :logit

  def initialize
    @data = Array.new
    @biggest_area = 0
    @logit = true
  end

  def biggest_rect
    @data.each.with_index do |loc1,i|
      x1, y1 = loc1.split(',').map(&:to_i)

      @data[i+1..].each do |loc2|
        x2, y2 = loc2.split(',').map(&:to_i)
        this_area = ((y2 - y1).abs + 1) * ((x2 - x1).abs + 1)
        if this_area > @biggest_area
          @biggest_area = this_area
          puts "new biggest area #{x1},#{y1}-#{x2},#{y2} = #{this_area}"
        end
      end
    end

    return @biggest_area
  end

end

tiles = RedTiles.new

#fn = "input08-sample.txt"
fn = "input08.txt"

tiles.data = File.read(fn).split("\n")
tiles.logit = tiles.data.length < 50
unless tiles.data.empty?
  #tiles.max_rows = tiles.data.size
  puts "#{ tiles.data.length } rows"

  if tiles.logit 
    tiles.data.each do |s| 
      x,y = s.split(",").map(&:to_i)
      puts "x = #{x}, y = #{y}"
    end
  end
  
  puts "area of biggest red tile rectangle = #{ tiles.biggest_rect }."
end