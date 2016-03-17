# @Author: Benjamin Held
# @Date:   2015-08-27 12:21:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-17 19:40:44

module Input

  # This class holds the menu for query options regarding person and task query
  # and the addition of people or tasks
  class DatabaseOption < Base

    require_relative '../query/query'

    # main entry point, this method gets the {DataHandler} from the {MainMenu}
    # to work on the repository and to initiate the save operation
    def self.database_menu
      Query.initialize_repository(Input.data_handler.repository)
      print_menu('Input (1-5): ')
    end

    private

    # method to print the available menu entries
    def self.print_menu_items
      puts "\nDatabase options"
      puts ' (1) Add entity.'
      puts ' (2) Query entities.'
      puts ' (3) Query worktime.'
      puts ' (4) Save and exit.'
      puts ' (5) Abort and exit.'
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    def self.process_input(input)
      case input
        when 1 then EntityAddition.entity_addition_menu
        when 2 then EntityQueries.entity_query_menu
        when 3 then WorktimeQueries.worktime_query_menu
        when 4 then save_and_exit
        when 5 then Input.exit_script
      else
        puts "Error: #{input} ist not valid.".red
      end
      return true
    end

    # method to save the current repository and exit the script
    def self.save_and_exit
      begin
        Input.data_handler.save_repository
        Input.exit_script
      rescue IOError => e
        raise IOError, 'Error while saving data: '.concat(e.message).red
      end
    end

  end

end
