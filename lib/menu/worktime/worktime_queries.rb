# @Author: Benjamin Held
# @Date:   2016-02-23 19:31:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-07 16:28:40

module Menu

  require_relative 'time_menu'

  # singleton class to process the queries of different worktime intervals
  class WorktimeQueries < Base

    # main entry point to start a query on a person or task
    def self.worktime_query_menu
      print_menu('Input (1-4): ')
    end

    private

    # method to print the available menu entries
    def self.print_menu_items
      puts 'Queries for tasks done in a given time interval.'
      puts ' (1) Weekly worktime.'
      puts ' (2) Monthly worktime.'
      puts ' (3) Custom worktime interval.'
      puts ' (4) Cancel and return to previous menu.'
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    # @return [Boolean] true: if the a query type was used,
    #    false: if the script should return to the previous menu
    def self.process_input(input)
      case input
        when 1 then TimeMenu::WeektimeMenu::worktime_query_menu
        when 2 then TimeMenu::MonthtimeMenu::worktime_query_menu
        when 3 then custom_worktime
        when 4 then return false
      else
        puts "Error: #{input} ist not valid.".red
      end
      return true
    end

    # method to get the worktime for a given {Person} and interval
    def self.custom_worktime
      id = get_entry('Worktime for which ID? ').to_i
      start_time = Menu.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = Menu.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      Query::TimeQuery.get_time_worktime(id, start_time, end_time)
    end

  end

end
