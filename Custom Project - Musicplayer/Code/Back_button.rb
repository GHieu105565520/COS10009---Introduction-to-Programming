require 'gosu'

class BackButton
  def initialize(window)
    @window = window
    @back_button_image = Gosu::Image.new("Images/Back_button.png")
    @button_size = @window.height * 0.1 # Equal width and height for a circular appearance
    @back_button_x = 10
    @back_button_y = 10
  end

  def update
    # No hover effect needed
  end

  def draw
    @back_button_image.draw(@back_button_x, @back_button_y, 2, @button_size / @back_button_image.width, @button_size / @back_button_image.height)
  end

  def mouse_over_button?
    @window.mouse_x >= @back_button_x && @window.mouse_x <= @back_button_x + @button_size &&
    @window.mouse_y >= @back_button_y && @window.mouse_y <= @back_button_y + @button_size
  end

  def button_down(id)
    if id == Gosu::MS_LEFT && mouse_over_button?
      # Define what happens when the back button is clicked
      puts "Back button clicked!"
    end
  end
end
