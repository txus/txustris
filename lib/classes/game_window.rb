class GameWindow < Gosu::Window
  def initialize(w = 640, h = 480)
    # Set window size and caption
    super(w, h, false, 20)
    @width = w
    @height = h
    self.caption = "Txustris"

    Settings.load
    # Create a GUI for score and other data to be displayed during the game
    @GUI = GUI.new

    # Create a Menu of options
    @menu = Menu.new
    
    # Create a Player
    @player = Player.new

    # Create a tetris Grid
    @grid = Grid.new

    # Create a Hall Of Fame for records to be shown and stored
    @hall_of_fame = HallOfFame.new

    # Set keyboard sensitivity to human standards
    @rotation_sensitivity = 100
    @moving_sensitivity = 30

    # Set last time of all events to now
    @last_drop = @last_rotation = @last_move = @last_space = @last_esc = Gosu::milliseconds

    # Set starting level to 1 and lines to 0 by default
    @lines = 0
    @level = 1

    # Determine speed for each level according to ACCELERATION_FACTOR
    set_level_speeds
    
  end

  def show
    
  end

  private

  def set_level_speeds
    initial_speed = INITIAL_SPEED
    factor = 0.95
    (1..20).each do |num|
      #@speed_per_level.merge!(num => (initial_speed *= factor).to_i)
      factor *= 0.988
    end
  end
end
