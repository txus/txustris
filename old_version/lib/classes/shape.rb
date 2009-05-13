class Shape
  attr_accessor :x, :y, :color, :blocks
  
  @@active = nil
  @@instances = Array.new
  
  def initialize(window,grid,points,color,rotation = 0)
    @grid = grid
    
    @x = grid.x + 2*BLOCK_SIZE
    @y = grid.y + 2*BLOCK_SIZE
    
    @x, @y = grid.x + 2*BLOCK_SIZE, grid.y + 2*BLOCK_SIZE
    
    @color = Gosu::Color.new(0xff000000)
    @color.red = (rand (0-215)) + 40
    @color.green = (rand (0-215)) + 40
    @color.blue = (rand (0-215)) + 40
    
    rownum = 0
    @blocks = Array.new
    @matrix = points
    
    @rotation = rotation
    
    @points = points[@rotation].map do |row|
      colnum = 0
      a = row.map do |column|
        if column == 1 then
          column = Block.new(window,@grid,@color,BLOCK_SIZE, @x, @y, colnum, rownum)
          @blocks << column
        else
          column = nil
        end
        colnum += 1
      end
      rownum += 1
    end

    @window = window
    
    @@instances << self
  end
  
  def active?
    return true if @@active == self
    return false if @@active != self
  end
  
  def active!
    @@active = self
  end
  
  def warp(row,column)
    @all_blocks = Block.instances.dup
    @all_blocks.reject! do |other_block|
      @blocks.include? other_block
    end
    
    if row.is_a?(Symbol) then
      case row
        when :top:
          row = 0
        when :middle:
          row = @grid.rows/2
        else
          row = 0
      end
    end
    if column.is_a?(Symbol) then
      case column
        when :left:
          column = 0
        when :center:
          column = @grid.columns/2
        else
          column = @grid.columns/2
      end
    end
    
    collisions = 0
    @all_blocks.each do |other_block|
      @blocks.each do |block|
        if other_block.x == block.x and other_block.y == block.y then
          collisions += 1
        end
      end
    end
    if collisions == 0 then
      @x = @grid.x + column * BLOCK_SIZE
      @y = @grid.y + row * BLOCK_SIZE
    else
      @window.game_over!
    end
  end
  
  def draw
    @blocks.each do |block|
      block.x = @x + block.colnum * BLOCK_SIZE
      block.y = @y + block.rownum * BLOCK_SIZE
      block.draw
    end
  end
  def update_shape_rotating
    @rotation_fake = (@rotation + 1)%4

    temp = []
    @blocks.each do |block|
      block.fake = true
      block.destroy
      temp << block
    end
    @blocks = []
    
    @blocks_fake = Array.new
    rownum = 0
    @points_fake = @matrix[@rotation].map do |row|
      colnum = 0
      a = row.map do |column|
        if column == 1 then
          column = Block.new(@window,@grid,@color,BLOCK_SIZE, @x, @y, colnum, rownum, :fake)
          if column.trespasses_grid? or column.overlaps_block? then
            #Block.unfake_all
            temp.each do |temporal|
              temporal.fake = false
              temporal.revive
            end
            Block.destroy_fakes
  
            @blocks = temp
            return
          end
          @blocks_fake << column
        else
          column = nil
        end
        colnum += 1
      end
      rownum += 1
    end

    @rotation = @rotation_fake
    @points = @points_fake
    Block.unfake_all

    @blocks = @blocks_fake


    
  end
  def move(direction)
    if Gosu::milliseconds - @window.last_move > @window.moving_speed then
      case direction
        when :left:
          if fits? :left then
            @x -= BLOCK_SIZE
          end
        when :right:
          if fits? :right then
            @x += BLOCK_SIZE
          end
        when :down:
          if fits? :down then
            @y += BLOCK_SIZE
          end
      end
      @window.last_move = Gosu::milliseconds
    end

  end
  
  def fits?(direction)
    return false if touches_border?(direction) or touches_another_block?(direction)
    return true
  end
  
  def touches_border?(direction)
    @blocks.each do |block|
      case direction
        when :left:
          return true if block.x - @grid.border_left < BLOCK_SIZE
        when :right:
          return true if @grid.border_right - block.x <= BLOCK_SIZE
        when :down:
          if @grid.border_bottom - block.y <= BLOCK_SIZE then
            @window.new_piece
            return true
          end
      end
    end
    return false
  end
  def touches_another_block?(direction)

    @blocks.each do |block|
      case direction
        when :left:
          @all_blocks.each do |other_block|
            return true if block.x > other_block.x and block.x - other_block.x <= BLOCK_SIZE and block.y == other_block.y
          end
        when :right:
          @all_blocks.each do |other_block|
            return true if other_block.x > block.x and other_block.x - block.x <= BLOCK_SIZE and block.y == other_block.y
          end
        when :down:
          @all_blocks.each do |other_block|
            if other_block.y > block.y and other_block.y - block.y <= BLOCK_SIZE and block.x == other_block.x then
              if block.y == @grid.y then
                @window.game_over!
              else
               @window.new_piece
              end
              return true
            end
          end
      end
    end
    return false
  end
  
  def rotate
    if Gosu::milliseconds - @window.last_rotation > @window.rotation_speed then
      update_shape_rotating
      @window.last_rotation = Gosu::milliseconds
    end
  end
  
  def self.active
    @@active
  end
  def self.instances
    @@instances
  end
  
  def destroy
    @@instances.reject! do |shape|
      shape == self
    end
  end
  def self.destroy_all
    @@instances = []
  end
end