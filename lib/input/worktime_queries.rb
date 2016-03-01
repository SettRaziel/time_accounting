# @Author: Benjamin Held
# @Date:   2016-02-23 19:31:41
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-01 15:47:53

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
      values = get_input_values('Specify week of year: ')
      Query::WeekQuery.get_weekly_worktime(values[:id], values[:year],
                                           values[:time_frame])
    end

    # method to get the monthly worktime for a given {Person}, month and year
    def self.monthly_worktime
      values = get_input_values('Specify month of year: ')
      Query::MonthQuery.get_monthly_worktime(values[:id], values[:year],
                                             values[:time_frame])
    end

    # method to get the worktime for a given {Person} and interval
    def self.custom_worktime
      id = get_entry('Worktime for which ID? ').to_i
      start_time = Input.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = Input.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      Query::TimeQuery.get_time_worktime(id, start_time, end_time)
    end

    # method to retrieve the required input values
    # @param [String] time_string the string for the prompt collecting the
    #   time value
    def self.get_input_values(time_string)
      values = Hash.new()
      values[:id] = get_entry('Worktime for which ID? ').to_i
      values[:year] = get_entry('Specify year: ').to_i
      values[:time_frame] = get_entry(time_string).to_i
      return values
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
