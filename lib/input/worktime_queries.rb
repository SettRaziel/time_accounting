# @Author: Benjamin Held
# @Date:   2016-02-23 19:31:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-28 15:20:56

module Input

  # singleton class to process the queries of different worktime intervals
  class WorktimeQueries

    # main entry point to start a query on a person or task
    def self.worktime_query_menu
      is_not_finished = true
      while (is_not_finished)
        begin
          print_menu
          input = get_entry('Input (1-4): ').to_i

          is_not_finished = process_input(input)
        rescue StandardError => e
          puts "Error in WorktimeQuery: ".concat(e.message).red
        end
      end
    end

    private

    # method to print the available menu entries
    def self.print_menu
      puts 'Queries for tasks done in a given time interval.'
      puts ' (1) Weekly worktime.'
      puts ' (2) Monthly worktime.'
      puts ' (3) Custom worktime interval.'
      puts ' (4) Return to previous menu.'
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    # @return [Boolean] true: if the a query type was used,
    #    false: if the script should return to the previous menu
    def self.process_input(input)
      case input
        when 1 then weekly_worktime
        when 2 then monthly_worktime
        when 3 then custom_worktime
        when 4 then return false
      else
        puts "Error: #{input} ist not valid.".red
      end
      return true
    end

    # method to get the weekly worktime for a given {Person}, week and year
    def self.weekly_worktime
      id = get_entry('Worktime for which ID? ').to_i
      year = get_entry('Specify year: ').to_i
      week = get_entry('Specify week of year: ').to_i
      Query::WeekQuery.get_weekly_worktime(id, year, week)
    end

    # method to get the monthly worktime for a given {Person}, month and year
    def self.monthly_worktime
      id = get_entry('Worktime for which ID? ').to_i
      year = get_entry('Specify year: ').to_i
      month = get_entry('Specify month of year: ').to_i
      Query::MonthQuery.get_monthly_worktime(id, year, month)
    end

    # method to get the worktime for a given {Person} and interval
    def self.custom_worktime
      id = get_entry('Worktime for which ID? ').to_i
      start_time = Input.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = Input.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      puts start_time.inspect
      Query::TimeQuery.get_time_worktime(id, start_time, end_time)
    end

    # method to print a given message and read the provided input
    # @param [String] message output message
    # @return [String] the input from the terminal
    def self.get_entry(message)
      print message.blue.bright
      gets.chomp
    end

  end

end
