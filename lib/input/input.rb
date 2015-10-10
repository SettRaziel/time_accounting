# @Author: Benjamin Held
# @Date:   2015-08-24 12:43:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-10-10 17:47:47

require_relative '../handler/data_handler'

# This module holds the classes for the terminal menu, which can be used to
# run this program in a terminal window
module Input

  class << self
    attr_reader :data_handler
  end

  # method to set a new data handler
  # @param [DataHandler] data_handler the given data handler
  def self.initialize_datahandler(data_handler)
    @data_handler = data_handler
  end

  # method to end the script without saving any data
  def self.exit_script
    puts "Shutting down..."
    exit(0)
  end

  # This class creates the main menu for the script and holds methods to
  # load existing data or to create a new database. After that it delegates the
  # queries and additions to the data to the responsible classes
  class MainMenu

    # main entry point, this method prints the main menu and allows the highest
    # level decisions for the whole script
    def self.print_menu
      begin
        while (true)
          puts "Work Accounting v0.1. What do you want to do?"
          puts " (1) Create a new database."
          puts " (2) Load an existing database."
          puts " (3) Exit."
          process_input(get_entry("Input (1-3): ").to_i)
        end
      rescue SignalException => e
        puts "\nReceived SignalException, exiting..."
      end
    end

    private

    # method to print an error message
    # @param [String] message the error message that should be printed
    def self.print_error(message)
      puts message
    end

    # method to check the input and proceed depending on its value
    # @param [Integer] input the provided input
    def self.process_input(input)
      case input
        when 1 then create_database
        when 2 then load_database
        when 3 then Input.exit_script
      else
        print_error("Error: Input is not valid.")
      end
    end

    # method to start the creation of the new database. The user is asked to
    # provide a name for the database or file
    def self.create_database
      filename = initialize_database("Create a new database.")
      Input.initialize_datahandler(DataHandler.new(filename))
      puts "Database #{filename} created."
    end

    # method to load an existing database. The user is asked to provide the
    # path to the database
    def self.load_database
      filename = initialize_database("Load an existing database.")
      Input.initialize_datahandler(DataHandler.load_database(filename))
      puts "Database #{filename} created."
    end

    # method to display the provided message and read the filename of the
    # database
    # @param [String] message the output message
    # @return [String] the provided filename
    def self.initialize_database(message)
      puts message
      get_entry("Input a name for the database: ")
    end

    # method to print a message and read the following input
    # @param [String] message prompt message
    # @return [String] the provided input
    def self.get_entry(message)
      print message
      gets.chomp
    end

  end

end
