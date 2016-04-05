# @Author: Benjamin Held
# @Date:   2016-03-25 12:22:05
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-05 17:38:55

module Menu

  module TimeMenu

    require_relative '../../query/query'

    class TimeMenu < Base

      private
      attr :time_string
      attr :values

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
        puts ' (4) Cancel and return to previous menu.'
      end

      # method to process the provided input
      # @param [Integer] input the provided input
      # @return [Boolean] true: if the a query type was used,
      #    false: if the script should return to the previous menu
      def self.process_input(input)
        case input
          when 1 then print_all_tasks
          when 2 then calculate_worktime
          when 3 then print_tasks_in_interval
          when 4
            @values = nil
            return false
        else
          puts "Error: #{input} ist not valid.".red
        end
        return true
      end

      def self.retrieve_tasks
        fail NotImplementedError, " Error: the subclass "
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_tasks from its parent class".red
      end

      def self.retrieve_worktime
        fail NotImplementedError, " Error: the subclass "
        "#{self.name.split('::').last} needs to implement the method: " \
        "retrieve_worktime from its parent class".red
      end

      def self.check_attributes
        if (@values == nil)
          puts "Specify necessary informations: "
          @values = (get_input_values("Specify #{@time_string} of year: "))
        end
        check_time_string
      end

      def self.check_time_string
        if @time_string.eql?(nil)
          fail NotImplementedError, " Error: the subclass "
          "#{self.name.split('::').last} does not present a string for " \
          "its attribute time_string".red
        end
      end

      def self.print_all_tasks
        tasks = retrieve_tasks
        tasks.each_key { |key|
          print_tasks_to_key(tasks[key]) if (tasks[key].size > 0)
        }
      end

      def self.print_tasks_to_key(tasks)
        tasks.each { |task|
          puts task.to_string
        }
      end

      def self.calculate_worktime
        retrieve_worktime
      end

      def self.print_tasks_in_interval
        tasks = retrieve_tasks
        print_tasks_to_key(tasks[:during])
      end

    end

  end

end

require_relative 'weektime_menu'
require_relative 'monthtime_menu'
