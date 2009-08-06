class HallOfFame
  def initialize(window,font,title_color,label_color,element_color)
    @window = window
    
    @records = []
    f = File.new("data/data.dat","r")
    f.each_line do |line|
      unless line.size < 4 then
        data = line.chomp.split ','
        @records << Record.new(data[0],data[1],data[2])
      end
    end
    f.close
    
    @font = font
    @title_color = title_color
    @label_color = label_color
    @element_color = element_color
    

  end
  def draw
    @font.draw("Hall of fame",(@window.width / 3 + 20),@window.height/6,1,2,2,@title_color)
    initial_hof_x = @window.width / 4
    initial_hof_y = @window.height/7 + 100
    x_offset = 0
    y_offset = 0
    tables_x = [initial_hof_x, initial_hof_x + 150, initial_hof_x + 300]
    
    @font.draw("Name",tables_x[0],initial_hof_y -30,1,1,1,@label_color)
    @font.draw("Level",tables_x[1],initial_hof_y -30,1,1,1,@label_color)
    @font.draw("Score",tables_x[2],initial_hof_y -30,1,1,1,@label_color)
    
    @records.each do |record|
      @font.draw(record.name,tables_x[0],initial_hof_y + y_offset,1,1,1,@element_color)
      @font.draw(record.level,tables_x[1],initial_hof_y + y_offset,1,1,1,@element_color)
      @font.draw(record.score,tables_x[2],initial_hof_y + y_offset,1,1,1,@element_color)      
      y_offset += 20
    end
  end
  def new_record(name, score, level)
    f = File.new("data/data.dat","a")
    f << "\n#{name},#{score},#{level}\n"
    f.close
    @records << Record.new(name,score,level)
  end
  
end
class Record
  attr_accessor :name, :score, :level
  def initialize(name, score, level)
    @name = name
    @score = score
    @level = level
  end
end