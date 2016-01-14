# @Author: Benjamin Held
# @Date:   2015-08-26 15:03:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-14 18:42:45

module Query

  # statistic class to calculate to work time for a given week of the year
  class WeekQuery < Base

    # method to retrieve the worktime for a person for the given year and week
    # @param [Integer] id the id of the person
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week of the year
    def self.get_weekly_worktime(id, year, calendar_week)
      get_interval_worktime(id, year, calendar_week, (7*24))
    end

    private

    # method to calculate the lower time boundary for the given week
    # (the start of the week)
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week of the year
    # @return [Time] the start of the monday in the requested week
    def self.get_monday_of_calendar_week(year, calendar_week)
      start = Time.new(year)

      # Monday of calendar week 1
      start = get_next_monday(start)
      start += (calendar_week - 2) * 7 * 60 * 60 * 24
    end

    # method to calculate the upper time boundary for the given week
    # (the end of the week)
    # @param [Time] time the start time of the requested week
    # @return [Time] the time of the monday of the follwing week
    def self.get_next_monday(time)
      time + (7 - time.get_int_wday) * 60 * 60 * 24
    end

    # method to calculate the time boundaries for the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @return [Hash] a hash containing the two time boundaries
    def self.calculate_start_and_end_day(year, calendar_week)
      start_time = get_monday_of_calendar_week(year, calendar_week)
      end_time = get_next_monday(start_time)
      {:actual => Time.new(start_time.year, start_time.month, start_time.day),
       :next => end_time}
    end

    # method to get all tasks taking place during the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_during(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      collect_tasks_during(days, all_task)
    end

    # method to get all tasks taking place throughout the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_over(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      collect_tasks_over(days, all_task)
    end

    # method to get all tasks starting before the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_into(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      collect_tasks_into(days, all_task)
    end

    # method to get all tasks ending after the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_beyond(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      collect_tasks_beyond(days, all_task)
    end

    # method to calculate the worktime within the week for tasks starting
    # before the requested week
    # @param [Array] tasks the tasks starting before the requested week for
    #    the requested person
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @return [Float] the working time for these tasks within the requested
    #    week in hours
    def self.get_hours_into(tasks, year, calendar_week)
      start_time = calculate_start_and_end_day(year, calendar_week)[:actual]
      get_into_value(tasks, start_time)
    end

    # method to calculate the worktime within the week for tasks ending
    # after the requested week
    # @param [Array] tasks the tasks ending after the requested week for
    #    the requested person
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @return [Float] the working time for these tasks within the requested
    #    week in hours
    def self.get_hours_beyond(tasks, year, calendar_week)
      next_calendar_week =
                   calculate_start_and_end_day(year, calendar_week)[:next]
      get_beyond_value(tasks, next_calendar_week)
    end

  end

end
