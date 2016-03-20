require 'rubygems'
require 'gosu'
require_relative 'zorder'
require_relative 'player'

class JoustGame < Gosu::Window
  WIDTH = 600
  HEIGHT = 400
  SCALE = 1.5
  SCREENS = [
    "joustintro.gif", 
    "jouststart.gif", 
    "joustscores.gif"].map { |e| "media/" + e }

  def initialize
    super WIDTH, HEIGHT, false
    self.caption = "Joust"

    @background_image = Gosu::Image.new(SCREENS[0],
                                        :tileable => true)
    @player = Player.new
  end

  def update
    @player.update
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def draw 
    @background_image.draw(WIDTH / 2 - @background_image.width * SCALE / 2,
                           HEIGHT / 2 - @background_image.height * SCALE / 2,
                          ZOrder::Background, 1.5, 1.5)
    @player.draw
  end

end

window = JoustGame.new
window.show