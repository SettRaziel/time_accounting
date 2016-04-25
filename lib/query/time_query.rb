# @Author: Benjamin Held
# @Date:   2016-01-23 20:07:29
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-25 17:43:02

module Query

  # statistic class to calculate to work time for a given month and year
  class TimeQuery < Base

    # method to retrieve the worktime for a person for the given time
    # interval
    def self.get_time_worktime(id, start_time, end_time)
      times = calculate_start_and_end_time(start_time, end_time)
      get_interval_worktime(id, times, (end_time - start_time) / 60 / 60)
    end

    # method to calculate the time boundaries for the given interval
    # @param [Time] start_time the start time of the interval
    # @param [Time] end_time the end time of the interval
    # @return [Hash] a hash containing the two time boundaries
    def self.calculate_start_and_end_time(start_time, end_time)
      {:actual => start_time, :next => end_time}
    end

  end

end
