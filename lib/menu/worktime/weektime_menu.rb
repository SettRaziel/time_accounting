# @Author: Benjamin Held
# @Date:   2016-03-25 12:13:48
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-01 12:41:11

module Menu

  module TimeMenu

    # menu class to present the available query options for a given week
    # and for a given entity, identified by its id
    class WeektimeMenu < IntervaltimeMenu

      # initialization
      def initialize
        super('week')
      end

      private

      # method to retrieve all task that started, ended or took place within
      # the given week for the provided id
      # @return [Hash] a hash mapping (task_type => Array) holding the queried
      #   tasks
      def retrieve_tasks
        Query.get_data(@values[:id], @values[:start_time], @values[:end_time])
      end

      # method to retrieve the overall worktime for an entity with the given id
      # for the given week
      # @return [Hash] a hash with the hours for each type of task
      def retrieve_worktime
        Query.get_weekly_worktime(@values[:id], @values[:start_time],
                                             @values[:end_time])
      end

      # method to calculate the date boundaries of the provided user input
      def set_boundaries
        days = calculate_start_and_end_day(@values[:year], @values[:time_frame])
        set_values(days)
        return "Calculated interval for week from input:" \
               " #{days[:actual]} - #{days[:next]}"
      end

      # method to calculate the time boundaries for the given week
      # @param [Integer] year the requested year
      # @param [Integer] calendar_week the requested week
      # @return [Hash] a hash containing the two time boundaries
      def calculate_start_and_end_day(year, calendar_week)
        start_time = get_monday_of_calendar_week(year, calendar_week)
        end_time = get_next_monday(start_time)
        {:actual => Time.new(start_time.year, start_time.month, start_time.day),
         :next => Time.new(end_time.year, end_time.month, end_time.day)}
      end

      # method to calculate the lower time boundary for the given week
      # (the start of the week)
      # @param [Integer] year the requested year
      # @param [Integer] calendar_week the requested week of the year
      # @return [Time] the start of the monday in the requested week
      def get_monday_of_calendar_week(year, calendar_week)
        start = Time.new(year)

        # Monday of calendar week 1
        start = get_next_monday(start)
        start + (calendar_week - 2) * 7 * 60 * 60 * 24
      end

      # method to calculate the upper time boundary for the given week
      # (the end of the week)
      # @param [Time] time the start time of the requested week
      # @return [Time] the time of the monday of the follwing week
      def get_next_monday(time)
        time + (7 - time.get_int_wday) * 60 * 60 * 24
      end

    end

  end

end
