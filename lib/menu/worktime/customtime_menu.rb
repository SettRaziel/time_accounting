# @Author: Benjamin Held
# @Date:   2016-05-13 08:59:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-22 20:24:07

module Menu

  # This module holds the menu classes that are used to display the options for
  # queries based on the time interval that is presented
  module TimeMenu

    # class to present the available query options for a given month
    # and for a given entity, identified by its id
    class CustomtimeMenu < TimeMenu

      # initialization
      def initialize
        super('custom interval')
      end

      private

      # method to retrieve the required input values
      def get_input_values
        @values = Hash.new()
        @values[:id] = get_entry('Worktime for which ID? ').to_i
        @values[:start_time] = Menu.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
        @values[:end_time] = Menu.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      end

      # method to calculate the date boundaries of the provided user input
      def set_boundaries
        return "Calculated interval for week from input:" \
               " #{@values[:start_time]} - #{@values[:end_time]}"
      end

      # method to retrieve all task that started, ended or took place within
      # the custom time interval for the provided id
      # @return [Hash] a hash mapping (task_type => Array) holding the queried
      #   tasks
      def retrieve_tasks
        Query.get_data(@values[:id], @values[:start_time], @values[:end_time])
      end

      # method to retrieve the overall worktime for an entity with the given id
      # for the custom time interval
      def retrieve_worktime
        Query.get_time_worktime(@values[:id], @values[:start_time],
                                              @values[:end_time])
      end

    end

  end

end
