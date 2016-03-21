require 'rubygems'
require 'gosu'
require_relative 'zorder'

class Player
  OSTRICH = Gosu::Image::load_tiles("media/player_one_bird.bmp", 
                                           16, 20)
  #STORK = Gosu::Image::load_tiles("media/player_two_bird.bmp", ##, ##)
  # TODO: Need to extract sprites for player2
  STORK = nil

  # Defines the four states of motion
  WALKING, BRAKING, FLAPPING, FALLING = *1..4

  # Define frames in spritesheet used for each movement
  WALK_FRAMES = *0..3
  BRAKE_FRAMES = 4
  FLAP_FRAMES = *5..6

  # Directions
  LEFT = -1
  RIGHT = 1

  # Used to make walking animation feel more natural
  SPEED_OFFSET = 25.0

  MAX_XVEL = 15.0
  X_ACCEL = 0.3
  Y_ACCEL = 1.3

  def initialize(canvas_width, canvas_height, player_num = 1, 
                 single_player = true)
    if single_player
      @up_key = Gosu::KbSpace
    else
      @up_key = player_num == 1 ? Gosu::KbUp : Gosu::KbW
    end
    @left_key = player_num == 1 ? Gosu::KbLeft : Gosu::KbA
    @right_key = player_num == 1 ? Gosu::KbRight : Gosu::KbD

    @canvas_height = canvas_height
    @canvas_width = canvas_width

    @x = @y = 20
    @xvel = 0.0
    @yvel = 0.0
    @dir = RIGHT
    @state = WALKING
    # fc is frame counter for animation
    @fc = 0.0

    @bird_frames = player_num == 1 ? OSTRICH : STORK

    # HACK: Is there a better way?
    @up_pressed_before = false
  end

  def update
    @dir = @xvel < 0 ? LEFT : RIGHT
    @state = FALLING if @yvel < 0

    case @state
    when BRAKING
      # Range needed because of trailing digits in value
      if ((-1 * X_ACCEL)..X_ACCEL).include? @xvel
        @state = WALKING
        @fc = WALK_FRAMES[0]
      else
        @fc = BRAKE_FRAMES
      end
    when WALKING
      @fc += @dir * @xvel / SPEED_OFFSET
      @fc %= WALK_FRAMES.size
    when FALLING
      @fc = FLAP_FRAMES[1]
    else 
      @fc += 0.25
    end

    if Gosu::button_down? @right_key
      @xvel += X_ACCEL unless @xvel >= MAX_XVEL
      @state = BRAKING if @dir == LEFT && @state == WALKING
    end
    if Gosu::button_down? @left_key
      @xvel -= X_ACCEL unless @xvel <= (-1 * MAX_XVEL)
      @state = BRAKING if @dir == RIGHT && @state == WALKING
    end
    if Gosu::button_down? @up_key
      unless @up_pressed_before
        @yvel = Y_ACCEL
        @fc = FLAP_FRAMES[0]
        @state = FLAPPING
        @up_pressed_before = true
      end
    else
      @up_pressed_before = false
    end

    if ((@state == FLAPPING) && 
       !((FLAP_FRAMES[0]...FLAP_FRAMES[1]).include? @fc))
      @state = FALLING
      @fc = FLAP_FRAMES[1]
    end

    @x += @xvel / SPEED_OFFSET * 2.45
    @y -= @yvel

    @x %= @canvas_width
    @y %= @canvas_height

    if @state == FALLING
      @yvel -= Y_ACCEL / 2
    end

    # NOTE: Take out, for testing now
    if @yvel <= -5
      @yvel = 0.0
      @state = WALKING
    end

  end

  def draw(scale = 1)
    @bird = @bird_frames[@fc.floor]
    @bird.draw(@x + (@dir == RIGHT ? 0 : @bird.width), # Offset for flip
               @y, ZOrder::Bird, @dir * scale, 1 * scale)
  end
end