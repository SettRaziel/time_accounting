module Menu

  # This class creates the main menu for the script and holds methods to
  # load existing data or to create a new database. After that it delegates the
  # queries and additions to the data to the responsible classes
  class MainMenu < Base

    # initialization
    def initialize
      super
      @menu_description = "Work Accounting v0.3.1. What do you want to do?"
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item("Create a new database.", 1)
      add_menu_item("Load an existing database.", 2)
      add_menu_item("Exit.", 3)
    end

    # method to print an error message
    # @param [String] message the error message that should be printed
    def print_error(message)
      puts message.red
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should exit
    def determine_action(input)
      case (input.to_i)
        when 1 then create_database
        when 2 then load_database
        when 3 then Menu.exit_script
      else
        handle_wrong_option
      end
      return true
    end

    # method to start the creation of the new database. The user is asked to
    # provide a name for the database or file
    def create_database
      filename = get_database_name("Create a new database.")
      AdapterMenu.new(filename).print_menu
      finish_database_initialization(filename)
    end

    # method to load an existing database. The user is asked to provide the
    # path to the database
    def load_database
      filename = get_database_name("Load an existing database.")
      begin
        AdapterMenu.new(filename).print_menu
      rescue IOError => e
        puts e.message.red
        return
      end
      finish_database_initialization(filename)
    end

    # method to finalize the database initialization and the call of the
    # next menu
    # @param [String] filename the provided filename
    def finish_database_initialization(filename)
      puts "Database created from: #{filename}.".green
      DatabaseOption.new.database_menu
    end

    # method to display the provided message and read the filename of the
    # database
    # @param [String] message the output message
    # @return [String] the provided filename
    def get_database_name(message)
      puts message
      get_entry("Input a name for the database: ")
    end

  end

end
