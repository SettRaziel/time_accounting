# @Author: Benjamin Held
# @Date:   2015-08-24 12:53:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-03 17:12:04

# this module holds the classes and methods for queries regarding the data
module Query

  require_relative '../entity/time'

  # dummy class to get access to the data from methods within the module
  class << self
    # @return [DataRepository] the database with the {Task}s and {Person}s
    attr :data
  end

  # This class provides the common methods of the query types.
  class Base

    # method to collect all tasks of a person in a given time interval
    # @param [Integer] id the id of the person
    # @param [Hash] boundaries a hash containing the start and end time of the
    #   requested time interval
    # @return [Hash] a hash with all tasks mapped on how the occur in the
    #   time interval
    def self.get_data(id, boundaries)
      all_task = Query.data.get_tasks_to_person(id)
      tasks = {
        :during => collect_tasks_during(boundaries, all_task),
        :over => collect_tasks_over(boundaries, all_task),
        :into => collect_tasks_into(boundaries, all_task),
        :beyond => collect_tasks_beyond(boundaries, all_task)
      }

      return tasks
    end

    # method to calculate the work time in the given time period
    # @param [Integer] id the id of the person
    # @param [Hash] boundaries a hash containing the start and end time of the
    #   requested time interval
    # @param [Integer] time_frame the time of the interval in hours
    # @return [Hash] a hash containing all time values for the considered
    #   intervals
    def self.get_interval_worktime(id, boundaries, time_frame)
      tasks = get_data(id, boundaries)
      times = {
        :during => get_hours_during(tasks[:during]),
        :over => (tasks[:over].size > 0 ? time_frame : 0),
        :into => get_hours_into(tasks[:into], boundaries[:actual]),
        :beyond => get_hours_beyond(tasks[:beyond], boundaries[:next])
      }

      return times
    end

    # method to collect all task that occur during the time interval
    # @param [Hash] date_values a hash containing the start time and the
    #   end time of the requested time interval
    # @param [Array] all_task the task with start and/ or end within the
    #   requested time interval
    # @return [Hash] all tasks taking place during the given time frame
    private_class_method def self.collect_tasks_during(date_values, all_task)
      all_task.select { |task|
        !task_starts_before?(task, date_values[:actual]) &&
        !task_ends_after?(task, date_values[:next])
      }
    end

    # method to collect all task that start before the time interval but do
    # not end in the time interval
    # @param [Hash] date_values a hash containing the start time and the
    #   end time of the requested time interval
    # @param [Array] all_task the task with start and/ or end within the
    #   requested time interval
    # @return [Hash] all tasks running over the given time frame
    private_class_method def self.collect_tasks_over(date_values, all_task)
      all_task.select { |task|
        task_starts_before?(task, date_values[:actual]) &&
        task_ends_after?(task, date_values[:next])
      }
    end

    # method to collect all task that end in the time interval but were
    # started before the requested interval
    # @param [Hash] date_values a hash containing the start time and the
    #   end time of the requested time interval
    # @param [Array] all_task the task with start and/ or end within the
    #   requested time interval
    # @return [Hash] all tasks ending in the given time frame
    private_class_method def self.collect_tasks_into(date_values, all_task)
      all_task.select { |task|
        task_starts_before?(task, date_values[:actual]) &&
        time_lies_in_interval?(task.end_time, date_values)
      }
    end

    # method to collect all task that start in the time interval but do not
    # end in the requested interval
    # @param [Hash] date_values a hash containing the start time and the
    #   end time of the requested time interval
    # @param [Array] all_task the task with start and/ or end within the
    #   requested time interval
    # @return [Hash] all tasks starting in the given time frame
    private_class_method def self.collect_tasks_beyond(date_values, all_task)
      all_task.select { |task|
        time_lies_in_interval?(task.start_time, date_values) &&
        task_ends_after?(task, date_values[:next])
      }
    end

    # method to determine if the point in time lies within the time interval
    # given by the data values
    # @param [Time] time the given point in time
    # @param [Hash] date_values two points in time creating a time interval
    # @return [Boolean] true: if time lies within the interval, false: if not
    private_class_method def self.time_lies_in_interval?(time, date_values)
      time > date_values[:actual] && time < date_values[:next]
    end

    # method to check if a given task starts before the specified date
    # @param [Task] task the given task
    # @param [Time] date_value the considered point in time
    # @return [Boolean] true: if the task starts before the given point in time
    #   false: if not
    private_class_method def self.task_starts_before?(task, date_value)
      task.start_time < date_value
    end

    # method to check if a given task ends after the specified date
    # @param [Task] task the given task
    # @param [Time] date_value the considered point in time
    # @return [Boolean] true: if the task ends after the given point in time
    #   false: if not
    private_class_method def self.task_ends_after?(task, date_value)
      task.end_time > date_value
    end

    # method to calculate the working hours of tasks occurring during the
    # requested time interval
    # @param [Array] tasks the tasks occurring during the time interval
    # @return [Float] the sum of the working hours
    private_class_method def self.get_hours_during(tasks)
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
    private_class_method def self.get_hours_into(tasks, time_frame)
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
    private_class_method def self.get_hours_beyond(tasks, next_time_frame)
      total = 0.0
      tasks.each { |task|
        total += next_time_frame - task.start_time
      }

      total = (total / 3600).round(2)
    end

  end

  # singleton method to initialize the data repository with the provided data
  # @param [DataRepository] data the created database
  def self.initialize_repository(data)
    @data = data
  end

  # singleton method to query to data for a person for a given month
  # @param [Integer] id the id of the queried person
  # @param [Integer] year the requested year
  # @param [Integer] month the requested month
  # @return [Hash] the hash containing the different data informations
  def self.get_monthly_data_for(id, year, month)
    months = MonthQuery.calculate_month_and_next_month(year, month)
    MonthQuery.get_data(id, months)
  end

  # singleton method to query to data for a person for a given week
  # @param [Integer] id the id of the queried person
  # @param [Integer] year the requested year
  # @param [Integer] week the requested week
  # @return [Hash] the hash containing the different data informations
  def self.get_weekly_data_for(id, year, week)
    days = WeekQuery.calculate_start_and_end_day(year, week)
    WeekQuery.get_data(id, days)
  end

  # singleton method to query to data for a person for a given time
  # interval
  # @param [Integer] id the id of the queried person
    # @param [Time] start_time the start time of the interval
    # @param [Time] end_time the end time of the interval
  # @return [Hash] the hash containing the different data informations
  def self.get_time_data_for(id, start_time, end_time)
    days = TimeQuery.calculate_start_and_end_time(start_time, end_time)
    TimeQuery.get_data(id, days)
  end

end

require_relative 'month_query'
require_relative 'time_query'
require_relative 'week_query'
