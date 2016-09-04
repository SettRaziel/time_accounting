# @Author: Benjamin Held
# @Date:   2015-08-26 15:03:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-04 16:22:16

module Query

  # statistic class to calculate to work time for a given week of the year
  class WeekQuery < Base

    # method to retrieve the worktime for a person for the given year and week
    # @param [Integer] id the id of the person
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week of the year
    def self.get_weekly_worktime(id, year, calendar_week)
      days = calculate_start_and_end_day(year, calendar_week)
      get_interval_worktime(id, days, (7*24))
    end

    # method to calculate the time boundaries for the given week
    # @param [Integer] year the requested year
    # @param [Integer] calendar_week the requested week
    # @return [Hash] a hash containing the two time boundaries
    def self.calculate_start_and_end_day(year, calendar_week)
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
    private_class_method def self.get_monday_of_calendar_week(year,
                                                              calendar_week)
      start = Time.new(year)

      # Monday of calendar week 1
      start = get_next_monday(start)
      start + (calendar_week - 2) * 7 * 60 * 60 * 24
    end

    # method to calculate the upper time boundary for the given week
    # (the end of the week)
    # @param [Time] time the start time of the requested week
    # @return [Time] the time of the monday of the follwing week
    private_class_method def self.get_next_monday(time)
      time + (7 - time.get_int_wday) * 60 * 60 * 24
    end

  end

end
