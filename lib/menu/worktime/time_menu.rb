# @Author: Benjamin Held
# @Date:   2016-03-25 12:22:05
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-20 19:32:18

module Menu

  module TimeMenu

    require_relative '../../query/query'
    require_relative '../../output/csv/csv_writer'

    # menu class that serves as a base class for menus used to query information
    # for a given time interval
    class TimeMenu < Base

      # initialization
      def initialize(time_string)
        @time_string = time_string
        @menu_description = "Queries for tasks done in the given " \
                            "#{@time_string}."
        super
      end

      private
      # @return [String] the string describing the given time interval
      attr :time_string
      # @return [Hash] a hash containing the requested input values to reuse
      # them as long as this menu is active
      attr :values
      # @return [Array] an array with specific additions for the output
      attr :additions

      # abstract method to retrieve the required input values
      # @abstract subclasses need to implement this method
      # @param [String] time_string the string for the prompt collecting the
      #   time value
      def get_input_values(time_string)
        fail NotImplementedError, " Error: the subclass " \
        "#{self.name.split('::').last} needs to implement the method: " \
        "get_input_values from its parent class".red
      end

      # method to define all printable menu items
      def define_menu_items
        check_attributes
        @menu_description.concat("\n #{set_boundaries}")
        add_menu_item("All tasks to a person in the given #{time_string}.", 1)
        add_menu_item("Worktime of a person in that #{time_string}.", 2)
        add_menu_item('All tasks running during the interval.', 3)
        add_menu_item('Write Query result to csv-file.', 4)
        add_menu_item('Cancel and return to previous menu.', 5)
      end

      # method to process the provided input
      # @param [Integer] input the provided input
      # @return [Boolean] true: if the a query type was used,
      #    false: if the script should return to the previous menu
      def determine_action(input)
        case (input.to_i)
          when 1 then print_all_tasks
          when 2 then retrieve_and_print_worktime
          when 3 then print_tasks_in_interval
          when 4 then output_to_csv
          when 5
            @values = nil
            return false
        else
          handle_wrong_option
        end
        return true
      end

      # method to print the worktime hours of the retrieved tasks
      def retrieve_and_print_worktime
        times = retrieve_worktime

        puts "printing new worktime"
        if (times[:over] > 0)
          puts "Worktime: #{times[:over]} h"
        else
          puts "tasks.over: 0.0 h"
          puts "tasks.during: #{times[:during]} h"
          puts "tasks.into: #{times[:into]} h"
          puts "tasks.beyond: #{times[:beyond]} h"
        end
      end

      # abstract method to retrieve the tasks for the given interval
      # @abstract subclasses need to implement this method
      # @raise [NotImplementedError] if the subclass does not have this method
      def retrieve_tasks
        fail NotImplementedError, " Error: the subclass " \
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_tasks from its parent class".red
      end

      # abstract method to retrieve the worktime for the given interval
      # @abstract subclasses need to implement this method
      # @raise [NotImplementedError] if the subclass does not have this method
      def retrieve_worktime
        fail NotImplementedError, " Error: the subclass " \
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_worktime from its parent class".red
      end

      # abstract method to calculate the date boundaries of the provided
      # user input
      # @abstract subclasses need to implement this method
      # @raise [NotImplementedError] if the subclass does not have this method
      def set_boundaries
        fail NotImplementedError, " Error: the subclass " \
        "#{Class.name.split('::').last} needs to implement the method: " \
        "set_boundaries from its base class".red
      end

      # method to check if the necessary input was already collected
      def check_attributes
        if (@values == nil)
          puts "Specify necessary informations: "
          get_input_values
          @additions = Array.new()
        end
        #check_time_string
      end

      # method check, if the subclass has set a value for the class attribute
      # @raise [NotImplementedError] if the subclass does not have set the value
      def check_time_string
        if @time_string.eql?(nil)
          fail NotImplementedError, " Error: the subclass " \
          "#{self.name.split('::').last} does not present a string for " \
          "its attribute time_string".red
        end
      end

      # method to print all the collected tasks
      def print_all_tasks
        tasks = retrieve_tasks
        @values[:result] = Array.new()
        tasks.each_key { |key|
          print_tasks_to_key(tasks[key]) if (tasks[key].size > 0)
        }
      end

      # method to print all tasks collected to a specific key
      # @param [Array] tasks an array containing all tasks of a given key
      def print_tasks_to_key(tasks)
        tasks.each { |task|
          puts task.to_string
          @values[:result] << task
        }
      end

      # method to print all tasks in the given time interval
      def print_tasks_in_interval
        tasks = retrieve_tasks
        @values[:result] = Array.new()
        print_tasks_to_key(tasks[:during])
      end

      # method to write the results into a csv formatted file
      def output_to_csv
        if (@values[:result] != nil)
          @additions << calculate_worktime
          filename = get_entry("Specify output file: ")
          p = Menu.data_handler.repository.find_person_by_id(@values[:id])
          CSVWriter.output(filename, p, @values[:result], @additions)
        else
          puts "Nothing to write right now."
        end
      end

      # method to calculate the overall worktime an return it
      # @return [String] a formatted string containing the calculated worktime
      def calculate_worktime
        times = retrieve_worktime
        if (times[:over] > 0)
          time = times[:over]
        else
          time = times[:during] + times[:into] + times[:beyond]
        end
        "Worktime:; #{time} h"
      end

    end

  end

end

require_relative 'intervaltime_menu'
require_relative 'customtime_menu'
