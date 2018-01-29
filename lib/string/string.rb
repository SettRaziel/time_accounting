# @Author: Benjamin Held
# @Date:   2015-05-30 08:57:40
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-30 17:38:05

# Extension of the class String to modify a String in color and type
# Note: \e stands for the esc code
# Note: not all modifications are available for every terminal application
class String

  # change the string to colored bright
  # @return [String] the formatted string
  def bright
    "\e[1m#{self}\e[0m"
  end

  # changes the color of the string to gray
  # @return [String] the formatted string
  def gray
    "\e[2m#{self}\e[0m"
  end

  # changes the format of the string to italic
  # @return [String] the formatted string
  def italic
    "\e[3m#{self}\e[0m"
  end

  # underlines the string
  # @return [String] the formatted string
  def underline
    "\e[4m#{self}\e[0m"
  end

  # changes the style of the string to blink (not supported by every terminal
  # application)
  # @return [String] the formatted string
  def blink
    "\e[5m#{self}\e[25m"
  end

  # exchanges the color and background of the string
  # @return [String] the formatted string
  def exchange_grounds
    "\e[7m#{self}\e[0m"
  end

  # changes the color of the string to the background color
  # @return [String] the formatted string
  def hide
    "\e[8m#{self}\e[0m"
  end

  # changes the color of the string to the default foreground color
  # @return [String] the formatted string
  def default_foreground
    "\e[39m#{self}\e[0m"
  end

  # changes the color of the string to the default background color
  # @return [String] the formatted string
  def default_background
    "\e[49m#{self}\e[0m"
  end

  # changes the color of the string to black
  # @return [String] the formatted string
  def black
    "\e[30m#{self}\e[0m"
  end

  # changes the color of the string to red
  # @return [String] the formatted string
  def red
    "\e[31m#{self}\e[0m"
  end

  # changes the color of the string to light_red
  # @return [String] the formatted string
  def light_red
    "\e[91m#{self}\e[0m"
  end

  # changes the color of the string to green
  # @return [String] the formatted string
  def green
    "\e[32m#{self}\e[0m"
  end

  # changes the color of the string to light_green
  # @return [String] the formatted string
  def light_green
    "\e[92m#{self}\e[0m"
  end

  # changes the color of the string to yellow
  # @return [String] the formatted string
  def yellow
    "\e[33m#{self}\e[0m"
  end

  # changes the color of the string to light_yellow
  # @return [String] the formatted string
  def light_yellow
    "\e[93m#{self}\e[0m"
  end

  # changes the color of the string to blue
  # @return [String] the formatted string
  def blue
    "\e[34m#{self}\e[0m"
  end

  # changes the color of the string to light_blue
  # @return [String] the formatted string
  def light_blue
    "\e[94m#{self}\e[0m"
  end

  # changes the color of the string to magenta
  # @return [String] the formatted string
  def magenta
    "\e[35m#{self}\e[0m"
  end

  # changes the color of the string to light_magenta
  # @return [String] the formatted string
  def light_magenta
    "\e[95m#{self}\e[0m"
  end

  # changes the color of the string to cyan
  # @return [String] the formatted string
  def cyan
    "\e[36m#{self}\e[0m"
  end

  # changes the color of the string to light_cyan
  # @return [String] the formatted string
  def light_cyan
    "\e[96m#{self}\e[0m"
  end

  # changes the color of the string to light_gray
  # @return [String] the formatted string
  def light_gray
    "\e[37m#{self}\e[0m"
  end

  # changes the color of the string to dark_gray
  # @return [String] the formatted string
  def dark_gray
    "\e[90m#{self}\e[0m"
  end

  # changes the color of the string to white
  # @return [String] the formatted string
  def white
    "\e[97m#{self}\e[0m"
  end

  # changes the background of the string to black
  # @return [String] the formatted string
  def black_bg
    "\e[40m#{self}\e[0m"
  end

  # changes the background of the string to red
  # @return [String] the formatted string
  def red_bg
    "\e[41m#{self}\e[0m"
  end

  # changes the background of the string to light_red
  # @return [String] the formatted string
  def light_red_bg
    "\e[101m#{self}\e[0m"
  end

  # changes the background of the string to green
  # @return [String] the formatted string
  def green_bg
    "\e[42m#{self}\e[0m"
  end

  # changes the background of the string to light_green
  # @return [String] the formatted string
  def light_green_bg
    "\e[102m#{self}\e[0m"
  end

  # changes the background of the string to yellow
  # @return [String] the formatted string
  def yellow_bg
    "\e[43m#{self}\e[0m"
  end

  # changes the background of the string to light_yellow
  # @return [String] the formatted string
  def light_yellow_bg
    "\e[103m#{self}\e[0m"
  end

  # changes the background of the string to blue
  # @return [String] the formatted string
  def blue_bg
    "\e[44m#{self}\e[0m"
  end

  # changes the background of the string to light_blue
  # @return [String] the formatted string
  def light_blue_bg
    "\e[104m#{self}\e[0m"
  end

  # changes the background of the string to magenta
  # @return [String] the formatted string
  def magenta_bg
    "\e[45m#{self}\e[0m"
  end

  # changes the background of the string to light_magenta
  # @return [String] the formatted string
  def light_magenta_bg
    "\e[105m#{self}\e[0m"
  end

  # changes the background of the string to cyan
  # @return [String] the formatted string
  def cyan_bg
    "\e[46m#{self}\e[0m"
  end

  # changes the background of the string to light_cyan
  # @return [String] the formatted string
  def light_cyan_bg
    "\e[106m#{self}\e[0m"
  end

  # changes the background of the string to white
  # @return [String] the formatted string
  def white_bg
    "\e[107m#{self}\e[0m"
  end

  # changes the background of the string to light_gray
  # @return [String] the formatted string
  def light_gray_bg
    "\e[47m#{self}\e[0m"
  end

  # changes the background of the string to dark_gray
  # @return [String] the formatted string
  def dark_gray_bg
    "\e[100m#{self}\e[0m"
  end

end
