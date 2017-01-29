# @Author: Benjamin Held
# @Date:   2017-01-29 09:24:31
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-29 09:26:23

module Menu

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

end
