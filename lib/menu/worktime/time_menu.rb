# @Author: Benjamin Held
# @Date:   2016-03-25 12:22:05
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-05-12 16:22:30

module Menu

  module TimeMenu

    require_relative '../../query/query'
    require_relative '../../output/csv/csv_writer'

    # menu class that serves as a base class for menus used to query information
    # for a given time interval
    class TimeMenu < Base

      private
      # @return [String] the string describing the given time interval
      attr :time_string
      # @return [Hash] a hash containing the requested input values to reuse
      # them as long as this menu is active
      attr :values
      attr :additions

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

      # method to print the available menu entries
      def self.print_menu_items
        check_attributes
        puts "Queries for tasks done in the given #{@time_string}."
        puts " (1) All task to a person in the #{@time_string}."
        puts ' (2) Worktime of a person in that interval.'
        puts ' (3) All tasks running during the interval.'
        puts ' (4) Write Query result to csv-file.'
        puts ' (5) Cancel and return to previous menu.'
      end

      # method to process the provided input
      # @param [Integer] input the provided input
      # @return [Boolean] true: if the a query type was used,
      #    false: if the script should return to the previous menu
      def self.process_input(input)
        case input
          when 1 then print_all_tasks
          when 2 then retrieve_and_print_worktime
          when 3 then print_tasks_in_interval
          when 4 then output_to_csv
          when 5
            @values = nil
            return false
        else
          puts "Error: #{input} ist not valid.".red
        end
        return true
      end

      def self.retrieve_and_print_worktime
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
      def self.retrieve_tasks
        fail NotImplementedError, " Error: the subclass "
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_tasks from its parent class".red
      end

      # abstract method to retrieve the worktime for the given interval
      # @abstract subclasses need to implement this method
      # @raise [NotImplementedError] if the subclass does not have this method
      def self.retrieve_worktime
        fail NotImplementedError, " Error: the subclass "
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_worktime from its parent class".red
      end

      # method to check if the necessary input was already collected
      def self.check_attributes
        if (@values == nil)
          puts "Specify necessary informations: "
          @values = (get_input_values("Specify #{@time_string} of year: "))
          @additions = Array.new()
        end
        check_time_string
      end

      # method check, if the subclass has set a value for the class attribute
      # @raise [NotImplementedError] if the subclass does not have set the value
      def self.check_time_string
        if @time_string.eql?(nil)
          fail NotImplementedError, " Error: the subclass "
          "#{self.name.split('::').last} does not present a string for " \
          "its attribute time_string".red
        end
      end

      # method to print all the collected tasks
      def self.print_all_tasks
        tasks = retrieve_tasks
        @values[:result] = Array.new()
        tasks.each_key { |key|
          print_tasks_to_key(tasks[key]) if (tasks[key].size > 0)
        }
      end

      # method to print all tasks collected to a specific key
      # @param [Array] tasks an array containing all tasks of a given key
      def self.print_tasks_to_key(tasks)
        tasks.each { |task|
          puts task.to_string
          @values[:result] << task
        }
      end

      # method to print all tasks in the given time interval
      def self.print_tasks_in_interval
        tasks = retrieve_tasks
        @values[:result] = Array.new()
        print_tasks_to_key(tasks[:during])
      end

      def self.output_to_csv
        if (@values[:result] != nil)
          @additions << calculate_worktime
          filename = input = get_entry("Specify output file: ")
          p = Menu.data_handler.repository.find_person_by_id(@values[:id])
          CSVWriter.output(filename, p, @values[:result], @additions)
        else
          puts "Nothing to write right now."
        end
      end

      def self.calculate_worktime
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

require_relative 'weektime_menu'
require_relative 'monthtime_menu'
