class Block
  attr_accessor :x, :y, :colnum, :rownum, :fake
  @@blocks = []
  def initialize(window,grid,color,size,parent_x,parent_y,colnum,rownum, fake = nil)
    @color = color
    @width = size
    @height = size
    @colnum = colnum
    @rownum = rownum
    @x = parent_x + @colnum * @width
    @y = parent_y + @rownum * @height
    @img = Gosu::Image.new(window,"media/block.png",true)
    @fake = false
    
    
    if fake then
      @fake = true
    end
    
    @@blocks << self
    
    @grid = grid

  end
  def draw
		@img.draw(@x,@y,1,1,1,@color, :additive)
  end
  def self.instances(filter = nil)
    if filter == :fake then
      a = @@blocks.dup.reject! do |block|
        block.fake == false
      end
      return a
    end
    return @@blocks
  end
    
    
  def destroy
    @@blocks.reject! do |block|
      block == self
    end
  end
  def revive
    @@blocks << self unless @@blocks.include? self
  end
  
  def self.destroy_fakes
    @@blocks.reject! do |block|
      block.fake == true
    end
  end
  def self.destroy_all
    @@blocks = []
  end
  def self.unfake_all
    @@blocks.each do |block|
      block.fake = false
    end
  end
  
  def drop
    @y += BLOCK_SIZE
  end
  
  def is_above_row?(row)
    return true if @y < @grid.y + row*BLOCK_SIZE
  end
  
  def trespasses_grid?
    return true if @x < @grid.x or @x >= @grid.border_right or @y < @grid.y or @y >= @grid.border_bottom
    false
  end
  
  def overlaps_block?
    blocks = @@blocks.dup
    blocks.reject! do |block|
      block.fake == true
    end
    blocks.each do |block|
      if @x == block.x and @y == block.y then
        puts "Can't move!"
        return true
      end
    end
    false
  end
end