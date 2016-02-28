# @Author: Benjamin Held
# @Date:   2016-02-28 15:08:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-28 15:12:23

module Input

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
        puts "\nReceived SignalException, exiting...".yellow
      end
    end

    private

    # method to print an error message
    # @param [String] message the error message that should be printed
    def self.print_error(message)
      puts message.red
    end

    # method to check the input and proceed depending on its value
    # @param [Integer] input the provided input
    def self.process_input(input)
      case input
        when 1 then create_database
        when 2 then load_database
        when 3 then Input.exit_script
      else
        print_error(' Error: Input is not valid.')
      end
    end

    # method to start the creation of the new database. The user is asked to
    # provide a name for the database or file
    def self.create_database
      filename = get_database_name("Create a new database.")
      Input.initialize_datahandler(DataHandler.new(filename))
      finish_database_initialization(filename)
    end

    # method to load an existing database. The user is asked to provide the
    # path to the database
    def self.load_database
      filename = get_database_name("Load an existing database.")
      begin
        Input.initialize_datahandler(DataHandler.load_database(filename))
      rescue IOError => e
        puts e.message.red
        return
      end
      finish_database_initialization(filename)
    end

    # method to finalize the database initialization and the call of the
    # next menu
    # @param [String] filename the provided filename
    def self.finish_database_initialization(filename)
      puts "Database #{filename} created.".green
      DatabaseOption.database_menu
    end

    # method to display the provided message and read the filename of the
    # database
    # @param [String] message the output message
    # @return [String] the provided filename
    def self.get_database_name(message)
      puts message
      get_entry("Input a name for the database: ")
    end

    # method to print a message and read the following input
    # @param [String] message prompt message
    # @return [String] the provided input
    def self.get_entry(message)
      print message.blue.bright
      gets.chomp
    end

  end

end
