# @Author: Benjamin Held
# @Date:   2016-09-27 10:24:59
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-28 19:23:03

module Query

  # singleton class to calculate time values for a given set of tasks
  class TimeAccumulator

    # method to calculate the work time in the given time period
    # @param [Integer] id the id of the person
    # @param [Time] start_time the start time of the time interval
    # @param [Time] end_time the end time of the time interval
    # @param [Integer] time_frame the time of the interval in hours
    # @return [Hash] a hash containing all time values for the considered
    #   intervals
    def self.get_interval_worktime(tasks, start_time, end_time, time_frame)
      times = {
        :during => get_hours_during(tasks[:during]),
        :over => (tasks[:over].size > 0 ? time_frame : 0),
        :into => get_hours_into(tasks[:into], start_time),
        :beyond => get_hours_beyond(tasks[:beyond], end_time)
      }

      return times
    end

    # method to calculate the working hours of tasks occurring during the
    # requested time interval
    # @param [Array] tasks the tasks occurring during the time interval
    # @return [Float] the sum of the working hours
    def self.get_hours_during(tasks)
      total = 0.0
      tasks.each { |task|
        total += task.end_time - task.start_time
      }

      total = (total / 3600).round(2)
    end

    # method to calculate the working hours of tasks ending during the
    # requested time interval, but starting before
    # @param [Array] tasks the tasks ending during the time interval
    # @param [Time] time_frame the start time of the interval
    # @return [Float] the sum of the working hours
    def self.get_hours_into(tasks, time_frame)
      total = 0.0
      tasks.each { |task|
        total += task.end_time - time_frame
      }

      total = (total / 3600).round(2)
    end

    # method to calculate the working hours of tasks starting during the
    # requested time interval, but ending after
    # @param [Array] tasks the tasks starting during the time interval
    # @param [Time] next_time_frame the end time of the interval
    # @return [Float] the sum of the working hours
    def self.get_hours_beyond(tasks, next_time_frame)
      total = 0.0
      tasks.each { |task|
        total += next_time_frame - task.start_time
      }

      total = (total / 3600).round(2)
    end

  end

end
