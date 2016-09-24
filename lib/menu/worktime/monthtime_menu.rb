# @Author: Benjamin Held
# @Date:   2016-04-05 17:36:03
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-24 13:53:46

module Menu

  # This module holds the menu classes that are used to display the options for
  # queries based on the time interval that is presented
  module TimeMenu

    # singleton class to present the available query options for a given month
    # and for a given entity, identified by its id
    class MonthtimeMenu < IntervaltimeMenu

      # initialization
      def initialize
        super('month')
      end

      private

      # method to retrieve all task that started, ended or took place within
      # the given month for the provided id
      # @return [Hash] a hash mapping (task_type => Array) holding the queried
      #   tasks
      def retrieve_tasks
        Query.get_data(@values[:id], @values[:start_time], @values[:end_time])
      end

      # method to retrieve the overall worktime for an entity with the given id
      # for the given month
      # @return [Hash] a hash with the hours for each type of task
      def retrieve_worktime
        Query.get_monthly_worktime(@values[:id], @values[:start_time],
                                   @values[:end_time])
      end

      # method to calculate the date boundaries of the provided user input
      def set_boundaries
        months = calculate_month_and_next_month(@values[:year],
                                                @values[:time_frame])
        @values[:start_time] = months[:actual]
        @values[:end_time] = months[:next]
        return "Calculated interval for month from input:" \
               " #{months[:actual]} - #{months[:next]}"
      end

      # method to calculate the time boundaries for the given month
      # @param [Integer] year the requested year
      # @param [Integer] month the requested month
      # @return [Hash] a hash containing the two time boundaries
      def calculate_month_and_next_month(year, month)
        check_date = Time.new(year, month)
        {:actual => check_date, :next => check_date.next_month}
      end

    end

  end

end
