# Import library
require 'gosu'
require_relative 'Edsheeran'

# Window music player
class Musicplayerwindow < Gosu::Window
  def initialize
    super 850, 650 # Width x Height
    self.caption = "Music Player Window" # Title of the window
    # Background image
    @background = Gosu::Image.new("D:/Programming/Ruby_coding/Musicplayer/Images/Background.jpg", tileable: true)
    # Load music data
    @albums = load_music_data("D:/Programming/Ruby_coding/Musicplayer/Code/Musicplayer.txt")
    # Load album artwork images
    @album_images = @albums.map { |album| Gosu::Image.new(album[:artwork]) }
    # Font for the text
    @font = Gosu::Font.new(40) # Increased font size for the main text
    # Font for the artist names
    @artist_font = Gosu::Font.new(25) # Increased font size for artist names
    # Scale factor for images
    @scale_factor = 0.65
    # Initialize hover and click states
    @hovered_index = nil
    @clicked_index = nil
  end

  # def update
  def update
    # Check for hover state
    check_hover
  end

  # def draw
  def draw
    # Upload image background
    @background.draw(0, 0, 0, width.to_f / @background.width, height.to_f / @background.height)
    # Draw the text
    draw_text
    # Draw the album images and artist names
    draw_album_images
  end

  private

  def load_music_data(file_path)
    albums = []
    current_album = nil

    File.foreach(file_path) do |line|
      line = line.strip
      next if line.empty?

      case line
      when /^Number of Albums:/
        # Skip this line
      when /^(\d+)(st|nd|rd|th) Album:/
        current_album = { tracks: [] }
        albums << current_album
      when /^Title: (.+)/
        current_album[:title] = $1
      when /^Artist: (.+)/
        current_album[:artist] = $1
      when /^Artwork: (.+)/
        current_album[:artwork] = $1
      when /^Number of Tracks: (\d+)/
        current_album[:number_of_tracks] = $1.to_i
      when /^Track (\d+): (.+)/
        current_album[:tracks] << { title: $2 }
      when /^Link (\d+): (.+)/
        current_album[:tracks].last[:link] = $2
      end
    end

    albums
  end

  def draw_text
    image_height = @album_images[0].height * @scale_factor
    spacing = 5
    total_height = 2 * image_height + spacing + @artist_font.height
    y_start = (height - total_height) / 2 + 50
    text_y = (y_start / 2) - (@font.height / 2)
    text_color = @hovered_index == -1 ? Gosu::Color::YELLOW : Gosu::Color::WHITE
    @font.draw_text("CHOOSE AN ALBUM TO PLAY", (width / 2) - (@font.text_width("CHOOSE AN ALBUM TO PLAY") / 2), text_y, 1, 1, 1, text_color)
  end

  def draw_album_images
    image_width = @album_images[0].width * @scale_factor
    image_height = @album_images[0].height * @scale_factor
    spacing = 5

    total_width = 2 * image_width + spacing
    total_height = 2 * image_height + spacing + @artist_font.height

    x_start = (width - total_width) / 2
    y_start = (height - total_height) / 2 + 50

    @album_images.each_with_index do |image, index|
      x = x_start + (index % 2) * (image_width + spacing)
      y = y_start + (index / 2) * (image_height + spacing + @artist_font.height)
      image.draw(x, y, 1, @scale_factor, @scale_factor)
      artist_name = @albums[index][:artist]
      text_color = (@hovered_index == index || @clicked_index == index) ? Gosu::Color::YELLOW : Gosu::Color::WHITE
      @artist_font.draw_text(artist_name, x + (image_width / 2) - (@artist_font.text_width(artist_name) / 2), y + image_height + 5, 1, 1, 1, text_color)
      draw_frame(x, y, image_width, image_height) if @hovered_index == index || @clicked_index == index
    end
  end

  def draw_frame(x, y, width, height)
    Gosu.draw_rect(x - 2, y - 2, width + 4, 2, Gosu::Color::YELLOW, 2)
    Gosu.draw_rect(x - 2, y + height, width + 4, 2, Gosu::Color::YELLOW, 2)
    Gosu.draw_rect(x - 2, y, 2, height, Gosu::Color::YELLOW, 2)
    Gosu.draw_rect(x + width, y, 2, height, Gosu::Color::YELLOW, 2)
  end

  def check_hover
    @hovered_index = nil
    image_width = @album_images[0].width * @scale_factor
    image_height = @album_images[0].height * @scale_factor
    spacing = 5

    total_width = 2 * image_width + spacing
    total_height = 2 * image_height + spacing + @artist_font.height

    x_start = (width - total_width) / 2
    y_start = (height - total_height) / 2 + 50

    @album_images.each_with_index do |image, index|
      x = x_start + (index % 2) * (image_width + spacing)
      y = y_start + (index / 2) * (image_height + spacing + @artist_font.height)
      if mouse_x >= x && mouse_x <= x + image_width && mouse_y >= y && mouse_y <= y + image_height
        @hovered_index = index
      end
    end

    text_y = (y_start / 2) - (@font.height / 2)
    if mouse_x >= (width / 2) - (@font.text_width("CHOOSE AN ALBUM TO PLAY") / 2) && mouse_x <= (width / 2) + (@font.text_width("CHOOSE AN ALBUM TO PLAY") / 2) && mouse_y >= text_y && mouse_y <= text_y + @font.height
      @hovered_index = -1
    end
  end

  def button_down(id)
    if id == Gosu::MsLeft
      @clicked_index = @hovered_index
      if @clicked_index == 0 # Assuming Ed Sheeran's album is the first one
       EdsheeranWindow.new.show
      end
    end
  end
end

Musicplayerwindow.new.show