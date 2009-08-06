class Menu
  attr_accessor :selected
  def initialize(window, options, font, title_color, option_color, selected_color)
    @options = options
    @window = window
    @last_move = Gosu::milliseconds 
    @selected = select(0,true)
    @font = font
    @title_color = title_color
    @option_color = option_color
    @selected_color = selected_color
  end
  
  def draw
    @font.draw("Txustris",(@window.width / 3 + 20),@window.height/7,1,3,3,@title_color)
    initial_menu_x = @window.width / 2.3
    initial_menu_y = @window.height/7 + 100
    x_offset = 0
    y_offset = 0
    
    available_options.each do |element|
      option=element[0]
      data=element[1]
      y_offset += 30
      color = @option_color
      color = @selected_color if @selected == element
      @font.draw(data,initial_menu_x + x_offset, initial_menu_y + y_offset, 1,1,1,color)
    end  
  end
  
  def select(which,force = false)
    if force == false then
      if (Gosu::milliseconds - @last_move > 100 )then
        if which.is_a?(Fixnum) then
          @options.each do |option|
            option[4] = false
            option[4] = true if option[0] == available_options.dup[which][0]
          end
          return available_options.dup[which]
        elsif which.is_a?(Symbol) then
          case which
            when :first:
              @selected = available_options.first
            when :next:
              @selected = select((selected_index + 1) % how_many?(available_options))
            when :previous:
              @selected = select((selected_index - 1) % how_many?(available_options))
            when :last:
              @selected = available_options.last
          end
        end
        @last_move = Gosu::milliseconds
      end
    else
      @options.each do |option|
        option[4] = false
        option[4] = true if option[0] == available_options.dup[which][0]
      end
      @selected = available_options.dup[which]
    end
  end
  
  def available_options
    available = @options.dup
    available.reject! do |option|
      option[2] == false
    end
    return available
  end
  
  def how_many?(group)
    g = group.dup
    return g.size
  end
  
  def selected_index
    index = 0
    available_options.each do |option|
      return index if @selected == option
      index += 1
    end
    return nil
  end
  
  def enable_option(which)
    @options.each do |option|
      option[2] = true if option[0] == which
    end
  end
  
  def disable_option(which)
    @options.each do |option|
      option[2] = false if option[0] == which
    end
  end
end