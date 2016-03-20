require 'rubygems'
require 'gosu'
require_relative 'player'
require_relative 'star'
require_relative 'zorder'

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = 'Space Stars Shooter'

    @background_image = Gosu::Image.new("media/space.png", 
                                        :tileable => true)
    @font = Gosu::Font.new(20)

    @player = Player.new
    @player.warp(320, 240)

    @star_anim = Gosu::Image::load_tiles("media/star.png", 25, 25)
    @stars = Array.new
  end

  def update
    if Gosu::button_down? Gosu::KbLeft
      @player.turn_left
    end
    if Gosu::button_down? Gosu::KbRight
      @player.turn_right
    end
    if Gosu::button_down? Gosu::KbUp
      @player.accelerate
    end
    @player.move
    @player.collect_stars(@stars)

    if rand(100) < 4 and @stars.size < 25
      @stars.push(Star.new(@star_anim))
    end
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
  
  def draw
    @player.draw
    @background_image.draw(0, 0, ZOrder::Background)
    @stars.each { |star| star.draw }
    @font.draw("Score: #{@player.score}", 10, 10, ZOrder::UI, 1.0, 1.0,
                0xff_ffff00)
  end
end

window = GameWindow.new
window.show
