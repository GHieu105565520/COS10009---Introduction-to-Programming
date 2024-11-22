require 'gosu'
require 'mp3info'

class BackstreetBoyWindow < Gosu::Window
  PURPLE = Gosu::Color.new(0xff_800080)  # Define a custom purple color

  def initialize
    super 850, 650
    self.caption = "Backstreet Boy Album"

    @background_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Backstreet_Boy_Background.jpeg", tileable: true)
    @back_button_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Back_button.png")
    @back_button_scale = 0.2
    @album_cover = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Backstreet_Boys.jpg")
    @track_box_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Track_box.png")
    @play_button_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Play.png")
    @play_button_hover_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Play_Hover.png")  # Add hover image
    @pause_button_image = Gosu::Image.new("D:/Programming/Ruby_coding/Images/Pause.png")  # Add pause button image
    @font_small = Gosu::Font.new(20)  # Reduced font size for song names
    @album_scale = 0.5  # Reduced scale for the album cover
    @track_box_scale = 0.5  # Reduced the scale for the track box

    @songs = ["I WANT IT THAT WAY", "NO PLACE", "AS LONG AS YOU LOVE ME", "CHANCES", "DON'T GO BREAKING MY HEART", "SHOW ME THE MEANING OF BEING LONELY"]
    @current_song = nil
    @playing = false  # Add a flag to track play/pause state
    @show_track_box = false  # Add a flag to track whether to show the track box
    @current_song_name = ""  # Track the current song name
  end

  def draw
    @background_image.draw(0, 0, 0, width.to_f / @background_image.width, height.to_f / @background_image.height)
    draw_back_button
    draw_album_cover_and_songs
    draw_track_box if @show_track_box  # Conditionally draw the track box
  end

  def draw_back_button
    @back_button_image.draw(10, 10, 1, @back_button_scale, @back_button_scale)
  end

  def draw_album_cover_and_songs
    total_height = @album_cover.height * @album_scale + @font_small.height * @songs.size
    gap = (height - total_height) / 8  # Closer gap between text

    # Draw album cover
    x_album = (width / 4) - (@album_cover.width * @album_scale) / 2 - 70  # Move a bit more to the left
    y_album = (height - @album_cover.height * @album_scale) / 2
    @album_cover.draw(x_album, y_album, 1, @album_scale, @album_scale)

    # Draw song list
    y_start = (height - (@font_small.height + gap) * @songs.size) / 2
    @songs.each_with_index do |song, index|
      y = y_start + index * (@font_small.height + gap)
      color = mouse_over_song?(width / 2 - 50, y, song) ? Gosu::Color::YELLOW : Gosu::Color::WHITE  # Move a bit to the left
      @font_small.draw_text(song, (width - @font_small.text_width(song)) / 2 - 50, y, 1, 1.0, 1.0, color)  # Move a bit to the left
    end
  end

  def draw_track_box
    # Draw track box image
    x_track_box = (3 * width / 4) - (@track_box_image.width * @track_box_scale) / 2 + 20  # Move to the right
    y_start = (height - (@font_small.height + (height - @font_small.height * @songs.size) / 8) * @songs.size) / 2
    y_track_box = y_start + ((@font_small.height + (height - @font_small.height * @songs.size) / 8) * @songs.size - @track_box_image.height * @track_box_scale) / 2
    @track_box_image.draw(x_track_box, y_track_box, 1, @track_box_scale, @track_box_scale)

    # Draw current song name in the middle of the track box
    song_name_x = x_track_box + (@track_box_image.width * @track_box_scale - @font_small.text_width(@current_song_name)) / 2
    song_name_y = y_track_box + (@track_box_image.height * @track_box_scale - @font_small.height) / 2 - 20  # Move up a bit
    @font_small.draw_text(@current_song_name, song_name_x, song_name_y, 2, 1.0, 1.0, Gosu::Color::WHITE)

    # Draw play/pause button inside the track box
    play_button_x = x_track_box + (@track_box_image.width * @track_box_scale - @play_button_image.width) / 2
    play_button_y = song_name_y + @font_small.height + 10  # Adjusted position
    if @playing
      @pause_button_image.draw(play_button_x, play_button_y, 1)
    else
      if mouse_over_play_button?(play_button_x, play_button_y)
        @play_button_hover_image.draw(play_button_x, play_button_y, 1)
      else
        @play_button_image.draw(play_button_x, play_button_y, 1)
      end
    end
  end

  def mouse_over_song?(x, y, song)
    mouse_x.between?(x, x + @font_small.text_width(song)) && mouse_y.between?(y, y + @font_small.height)
  end

  def mouse_over_back_button?
    mouse_x.between?(10, 10 + @back_button_image.width * @back_button_scale) && mouse_y.between?(10, 10 + @back_button_image.height * @back_button_scale)
  end

  def mouse_over_play_button?(x, y)
    mouse_x.between?(x, x + @play_button_image.width) && mouse_y.between?(y, y + @play_button_image.height)
  end

  def button_down(id)
    if id == Gosu::MsLeft
      if mouse_over_back_button?
        @current_song.stop if @current_song  # Stop the song if it's playing
        ForeignMusicWindow.new.show
        close
      else
        # Define play button position
        total_height = @album_cover.height * @album_scale + @font_small.height * @songs.size
        gap = (height - total_height) / 8  # Calculate gap
        y_start = (height - (@font_small.height + gap) * @songs.size) / 2
        x_track_box = (3 * width / 4) - (@track_box_image.width * @track_box_scale) / 2 + 20
        y_track_box = y_start + ((@font_small.height + gap) * @songs.size - @track_box_image.height * @track_box_scale) / 2
        play_button_x = x_track_box + (@track_box_image.width * @track_box_scale - @play_button_image.width) / 2
        play_button_y = y_track_box + (@track_box_image.height * @track_box_scale - @font_small.height) / 2 + @font_small.height - 10  # Move up a bit

        if mouse_over_play_button?(play_button_x, play_button_y)
          if @playing
            @current_song.pause
          else
            @current_song.play(true)
          end
          @playing = !@playing
        else
          @songs.each_with_index do |song, index|
            x = (width - @font_small.text_width(song)) / 2 - 50
            y = y_start + index * (@font_small.height + gap)
            if mouse_over_song?(x, y, song)
              @current_song_name = song
              @current_song = Gosu::Song.new("D:/Programming/Ruby_coding/Music/#{song.downcase.gsub(' ', '_')}.mp3")
              @current_song.stop  # Ensure the song is stopped initially
              @show_track_box = true  # Show the track box when the song name is clicked
              @playing = false  # Reset playing state
              break
            end
          end
        end
      end
    end
  end  
end
