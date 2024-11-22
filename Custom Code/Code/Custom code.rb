require 'gosu'
require_relative 'Foreign_Music'
require_relative 'Local_Music'

class MusicSelectionWindow < Gosu::Window
  def initialize
    super 850, 650
    self.caption = "Music Selection"

    @background_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Album_background.jpeg", tileable: true)
    @font_large = Gosu::Font.new(50)
    @font_small = Gosu::Font.new(30)
    @title = "CHOOSE TYPE OF THE MUSIC"
    @foreign_music = "FOREIGN MUSIC"
    @local_music = "LOCAL MUSIC"
    @hover_color = Gosu::Color::YELLOW
    @default_color = Gosu::Color::WHITE
    @click_color = Gosu::Color::YELLOW
    @clicked = false
  end

  def update
    @clicked = false if @clicked && Gosu.milliseconds - @click_time > 200
  end

  def draw
    @background_image.draw(0, 0, 0, width.to_f / @background_image.width, height.to_f / @background_image.height)
    draw_text_centered(@title, height / 2 - 100, @default_color, @font_large)
    draw_text_centered(@foreign_music, height / 2, text_color(@foreign_music), @font_small)
    draw_text_centered(@local_music, height / 2 + 60, text_color(@local_music), @font_small)
  end

  def draw_text_centered(text, y, color, font)
    x = (width - font.text_width(text)) / 2
    font.draw_text(text, x, y, 1, 1.0, 1.0, color)
  end

  def text_color(text)
    if mouse_over_text?(text)
      @clicked ? @click_color : @hover_color
    else
      @default_color
    end
  end

  def mouse_over_text?(text)
    font = text == @title ? @font_large : @font_small
    x = (width - font.text_width(text)) / 2
    y = case text
        when @title then height / 2 - 100
        when @foreign_music then height / 2
        when @local_music then height / 2 + 60
        end
    mouse_x.between?(x, x + font.text_width(text)) && mouse_y.between?(y, y + font.height)
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if mouse_over_text?(@foreign_music)
        @clicked = true
        @click_time = Gosu.milliseconds
        ForeignMusicWindow.new.show
        close
      elsif mouse_over_text?(@local_music)
        @clicked = true
        @click_time = Gosu.milliseconds
        LocalMusicWindow.new.show
        close
      end
    end
  end
end

MusicSelectionWindow.new.show
