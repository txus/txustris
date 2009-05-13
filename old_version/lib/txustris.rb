require 'rubygems'
require 'gosu'
require 'classes/piece_types'
require 'classes/game_window'
require 'classes/grid'
require 'classes/shape'
require 'classes/block'
require 'classes/z_order'
require 'classes/menu'
require 'classes/hall_of_fame'
require 'classes/text_field'

BLOCK_SIZE = 20
INITIAL_SCORE_PER_LINE = 50
BONUS_INCREASE_FACTOR = 0.8
LINES_PER_LEVEL = 6
INITIAL_SPEED = 1050

window = GameWindow.new
                 
window.show
