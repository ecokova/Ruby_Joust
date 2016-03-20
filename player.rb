require 'rubygems'
require 'gosu'
require_relative 'zorder'

class Player
  OSTRICH = Gosu::Image::load_tiles("media/player_one_bird.bmp", 
                                           16, 20)
  #STORK = Gosu::Image::load_tiles("media/player_two_bird.bmp", ##, ##)
  # TODO: Need to extract sprites for player2
  STORK = nil

  # Define frames in spritesheet used for each movement
  WALK = 0..3
  BRAKE = 4
  FLAP = 5..6

  # Directions
  LEFT = -1
  RIGHT = 1

  # Used to make walking animation feel more natural
  SPEED_OFFSET = 25.0

  def initialize(player_num = 1, single_player = true)
    if single_player
      @up_key = Gosu::KbSpace
    else
      @up_key = player_num == 1 ? Gosu::KbUp : Gosu::KbW
    end
    @left_key = player_num == 1 ? Gosu::KbLeft : Gosu::KbA
    @right_key = player_num == 1 ? Gosu::KbRight : Gosu::KbD

    @x = @y = 20
    @xvel = 10
    @dir = RIGHT
    # ac is animation counter
    @ac = 0.0

    @bird_frames = player_num == 1 ? OSTRICH : STORK

  end

  def update
    if Gosu::button_down? @right_key
      @dir = RIGHT
      walk
    elsif Gosu::button_down? @left_key
      @dir = LEFT
      walk
    end
  end

  def walk 
    @ac += 1.0 / (SPEED_OFFSET / @xvel)
    @ac %= WALK.size

    @x += @dir * (@xvel / SPEED_OFFSET * 2.3)
  end

  def draw(scale = 1)
    @bird = @bird_frames[@ac.floor]
    @bird.draw(@x + (@dir == RIGHT ? 0 : @bird.width), # Offset for flip
               @y, ZOrder::Bird, @dir * scale, 1 * scale)
  end
end