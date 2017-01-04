# @Author: Benjamin Held
# @Date:   2015-08-24 12:43:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-04 19:12:28

# This module holds the classes for the terminal menu, which can be used to
# run this program in a terminal window
module Menu

  require_relative '../handler/data_handler'
  require_relative '../output/string'

  # dummy class to get access to the data handler within the module
  class << self
    # @return [BaseHandler] the handler for the data storage
    attr_reader :data_handler
  end

  # This class provides the common methods of the different query menus
  # The children need to define the method {Menu::Base.define_menu_items} and
  # {Menu::Base.determine_action}. If the child class does not implement this
  # method {Menu::Base} raises a NotImplementedError.
  class Base

    # initialization
    # @param [String] description the headline of the menu
    def initialize(description=nil)
      @menu_items = Hash.new()
      if (description == nil)
        @menu_description = 'Default menu. Please add description: '
      end
      define_menu_items
      @menu_items = Hash[@menu_items.sort]
    end

    # method to print the menu to the terminal and wait for input
    def print_menu
      isFinished = true
      while (isFinished)
        puts @menu_description
        @menu_items.each_pair { |key, value|
          puts "(#{key}) #{value}"
        }

        isFinished = determine_action(get_entry('Select option: '))
      end
    end

    private

    # @return [Hash] a hash which maps (number => string) for the menu items
    attr :menu_items
    # @return [String] a string with the head description of the menu
    attr :menu_description

    # @abstract subclasses need to implement this method
    # @raise [NotImplementedError] if the subclass does not have this method
    def define_menu_items
      fail NotImplementedError, " Error: the subclass " \
        "#{self.name.split('::').last} needs to implement the method: " \
        "define_menu_items from its base class".red
    end

    # @abstract subclasses need to implement this method
    # @param [String] input the provided user input
    # @raise [NotImplementedError] if the subclass does not have this method
    def determine_action(input)
      fail NotImplementedError, " Error: the subclass " \
        "#{self.name.split('::').last} needs to implement the method: " \
        "determine_action from its base class".red
    end

    # default behavior when a user provides not valid input
    def handle_wrong_option
      print 'Option not available. '.red
      determine_action(get_entry('Select option: '))
    end

    # method to add a given key/value pair to the menu hash
    # @param [String] description the description of the menu item
    # @param [Integer] index the index that should be used as key
    def add_menu_item(description, index=nil)
      index = @menu_items.length + 1 if (index == nil)
      @menu_items[index] = description
    end

    # method to print a given message and read the provided input
    # @param [String] message output message
    # @return [String] the input from the terminal
    def get_entry(message)
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
