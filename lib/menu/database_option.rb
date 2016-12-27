# @Author: Benjamin Held
# @Date:   2015-08-27 12:21:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-27 08:33:29

module Menu

  # This class holds the menu for query options regarding person and task query
  # and the addition of people or tasks
  class DatabaseOption < Base

    require_relative '../query/query'

    # initialization
    def initialize
      super
      @menu_description = "\nDatabase options"
    end

    # main entry point, this method gets the {DataHandler} from the {MainMenu}
    # to work on the repository and to initiate the save operation
    def database_menu
      Query.initialize_repository(Menu.data_handler)
      print_menu
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('Add entity.', 1)
      add_menu_item('Query entities.', 2)
      add_menu_item('Query worktime.', 3)
      add_menu_item('Save and exit.', 4)
      add_menu_item('Abort and exit.', 5)
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should exit
    def determine_action(input)
      case (input.to_i)
        when 1 then EntityAddition.new.print_menu
        when 2 then EntityQueries.new.print_menu
        when 3 then WorktimeQueries.new.print_menu
        when 4 then save_and_exit
        when 5 then Menu.exit_script
      else
        handle_wrong_option
      end
      return true
    end

    # method to save the current repository and exit the script
    def save_and_exit
      begin
        Menu.data_handler.persist_data
        Menu.exit_script
      rescue IOError => e
        raise IOError, 'Error while saving data: '.concat(e.message).red
      end
    end

  end

end
