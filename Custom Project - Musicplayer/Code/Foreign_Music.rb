require 'gosu'
require_relative 'Ed_Sheeran'
require_relative 'Alan_Walker'
require_relative 'Charlie_Puth'
require_relative 'Maroon_5'
require_relative 'Imagine_Dragon'
require_relative 'Backstreet_Boy'

class ForeignMusicWindow < Gosu::Window
  def initialize
    super 850, 650
    self.caption = "Foreign Music Selection"

    @background_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Foreign_music_background.jpeg", tileable: true)
    @back_button = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Back_button.png")
    @font_large = Gosu::Font.new(50)
    @font_small = Gosu::Font.new(20)
    @albums = [
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Ed_Sheeran.jpg"), name: "Ed Sheeran" },
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Alan_Walker.jpg"), name: "Alan Walker" },
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Charlie_Puth.jpg"), name: "Charlie Puth" },
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Maroon_5.jpg"), name: "Maroon 5" },
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Imagine_Dragon.jpg"), name: "Imagine Dragons" },
      { image: Gosu::Image.new("D:/Programming/Ruby_coding/Images/Backstreet_Boys.jpg"), name: "Backstreet Boys" }
    ]
    @album_scale = 0.5
    @back_button_scale = 0.3
    @hover_color = Gosu::Color::YELLOW
    @default_color = Gosu::Color::WHITE
    @clicked_album = nil
  end

  def draw
    @background_image.draw(0, 0, 0, width.to_f / @background_image.width, height.to_f / @background_image.height)
    @back_button.draw(10, 10, 1, @back_button_scale, @back_button_scale)
    draw_text_centered("CHOOSE AN ALBUM", 70, @default_color, @font_large)
    draw_albums
  end

  def draw_text_centered(text, y, color, font)
    x = (width - font.text_width(text)) / 2
    font.draw_text(text, x, y, 1, 1.0, 1.0, color)
  end

  def draw_albums
    total_width = @albums[0][:image].width * @album_scale * 3 + 40
    start_x = (width - total_width) / 2
    start_y = 200

    @albums.each_with_index do |album, index|
      x = start_x + (index % 3) * (album[:image].width * @album_scale + 20)
      y = start_y + (index / 3) * (album[:image].height * @album_scale + 40)
      color = mouse_over_album?(x, y, album[:image]) ? @hover_color : @default_color
      album[:image].draw(x, y, 1, @album_scale, @album_scale)
      text_x = x + (album[:image].width * @album_scale - @font_small.text_width(album[:name])) / 2
      @font_small.draw_text(album[:name], text_x, y + album[:image].height * @album_scale + 5, 1, 1.0, 1.0, color)
      draw_border(x, y, album[:image], color) if color == @hover_color
    end
  end

  def draw_border(x, y, image, color)
    Gosu.draw_rect(x - 2, y - 2, image.width * @album_scale + 4, 2, color, 2)
    Gosu.draw_rect(x - 2, y + image.height * @album_scale, image.width * @album_scale + 4, 2, color, 2)
    Gosu.draw_rect(x - 2, y - 2, 2, image.height * @album_scale + 4, color, 2)
    Gosu.draw_rect(x + image.width * @album_scale, y - 2, 2, image.height * @album_scale + 4, color, 2)
  end

  def mouse_over_album?(x, y, image)
    mouse_x.between?(x, x + image.width * @album_scale) && mouse_y.between?(y, y + image.height * @album_scale)
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if mouse_over_back_button?
        MusicSelectionWindow.new.show
        close
      else
        @albums.each_with_index do |album, index|
          x = (width - @albums[0][:image].width * @album_scale * 3 - 40) / 2 + (index % 3) * (@albums[0][:image].width * @album_scale + 20)
          y = 200 + (index / 3) * (@albums[0][:image].height * @album_scale + 40)
          if mouse_over_album?(x, y, album[:image])
            if album[:name] == "Ed Sheeran"
              EdSheeranWindow.new.show
              close
            elsif album[:name] == "Alan Walker"
              AlanWalkerWindow.new.show
              close
            elsif album[:name] == "Charlie Puth"
              CharliePuthWindow.new.show
              close
            elsif album[:name] == "Maroon 5"
              Maroon5Window.new.show
              close
            elsif album[:name] == "Imagine Dragons"
              ImagineDragonWindow.new.show
              close
            elsif album[:name] == "Backstreet Boys"
              BackstreetBoyWindow.new.show
              close
            end
            break
          end
        end
      end
    end
  end

  def mouse_over_back_button?
    mouse_x.between?(10, 10 + @back_button.width * @back_button_scale) && mouse_y.between?(10, 10 + @back_button.height * @back_button_scale)
  end
end
