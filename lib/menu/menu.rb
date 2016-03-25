# @Author: Benjamin Held
# @Date:   2015-08-24 12:43:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-25 12:24:18

# This module holds the classes for the terminal menu, which can be used to
# run this program in a terminal window
module Menu

  require_relative '../handler/data_handler'
  require_relative '../output/string'

  class << self
    attr_reader :data_handler
  end

  # This class provides the common methods of the different query menus
  # The children need to define the method {#print_menu_items}. If the child
  # class does not implement this method {Input::Base} raises a
  # {NotImplementedError}.
  class Base
    private

    # method to print the menu corresponding to the child class
    # @param [String] input_string the input string which should be displayed
    #    for the promt line
    def self.print_menu(input_string)
      is_not_finished = true
      while (is_not_finished)
        begin
          print_menu_items
          input = get_entry(input_string).to_i

          is_not_finished = process_input(input)
        rescue StandardError => e
          puts "Error in #{self.name.split('::').last}: ".concat(e.message).red
        end
      end
    end

    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def print_menu_items
      fail NotImplementedError, " Error: the subclass #{self.class} " \
        "needs to implement the method: print_menu_items " \
        "from its base class".red
    end

    # method to print a given message and read the provided input
    # @param [String] message output message
    # @return [String] the input from the terminal
    def self.get_entry(message)
      print message.blue.bright
      gets.chomp
    end

  end

  # method to set a new data handler
  # @param [DataHandler] data_handler the given data handler
  def self.initialize_datahandler(data_handler)
    @data_handler = data_handler
  end

  # method to end the script without saving any data
  def self.exit_script
    puts "Shutting down...".yellow
    exit(0)
  end

  # method to parse a date from a given string
  # @param [String] string the string with the data
  # @return [Time] the newly created tme object
  def self.parse_date(string)
    time = string.split("-")
    Time.new(time[0], time[1], time[2],time[3],time[4])
  end

end

require_relative 'database_option'
require_relative 'main_menu'
require_relative 'person_option'
require_relative 'entity_addition'
require_relative 'entity_queries'
require_relative './worktime/worktime_queries'
