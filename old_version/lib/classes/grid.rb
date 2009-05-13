class Grid
  attr_accessor :x,:y,:rows,:columns,:border_left,:border_right,:border_bottom
  def initialize(window)
    @columns = 10
    @rows = 20
    @x = 200
    @y = 30
    
    @border_left = @x
    @border_right = @x + @columns * BLOCK_SIZE
    @border_bottom = @y + @rows * BLOCK_SIZE
    
    @color = Gosu::Color.new(0xff000000)
    @color.red = 60
    @color.green = 60
    @color.blue = 60
    @window = window
    @img = Gosu::Image.new(window,"media/block.png",true)
  end
  def draw
    rowindex = 0
    colindex = 0
    @rows.times do |row|
      @columns.times do |column|
    		@img.draw(@x + column * BLOCK_SIZE, @y + row * BLOCK_SIZE,1,1,1, @color, :additive)
      end
    end
  end
  def map!
    blocks = Block.instances.dup
    @map = Array.new(@rows).collect do |r|
      r = Array.new(@columns,0)
    end
    @rows.times do |row|
      @columns.times do |column|
        x = @x + column*BLOCK_SIZE
        y = @y + row*BLOCK_SIZE
        blocks.each do |block|
          if block.x == x and block.y == y then
            @map[row][column] = block.object_id
          end
        end
      end
    end
  end
  def check_lines
    lines = Hash.new
    map!
    rownum = 0
    @map.each do |row|
      object_ids = Array.new
      num = 0
      colnum = 0
      row.each do |column|
        if column != 0 then
          object_ids << column
          num += 1
        end
        colnum += 1
      end
      if object_ids.size == @columns then
        lines.merge!(rownum => object_ids)
      end
      rownum += 1
    end
    
    destroy_lines(lines) if not lines.empty?
  end
  
  def destroy_lines(lines)
    blocks = Block.instances.dup
    num = 0
    lines.sort.each do |row, objects|
      num += 1
      blocks.each do |block|
        block.destroy if objects.include? block.object_id
      end
      drop_all_blocks_above_row(row)
    end
    @window.score_lines(num)
  end
  
  def drop_all_blocks_above_row(row)
    blocks = Block.instances.dup
    blocks.each do |block|
      block.drop if block.is_above_row?(row)
    end
  end
end