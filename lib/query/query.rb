# @Author: Benjamin Held
# @Date:   2015-08-24 12:53:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-09-21 09:17:57

# this module holds the classes and methods for queries regarding the data
module Query

  require_relative '../entity/time'

  # dummy class to get access to the data from methods within the module
  class << self
    # @return [DataRepository] the database with the {Task}s and {Person}s
    attr :data
  end

  # method to collect all tasks of a person in a given time interval
  # @param [Integer] id the id of the person
  # @param [Hash] boundaries a hash containing the start and end time of the
  #   requested time interval
  # @return [Hash] a hash with all tasks mapped on how the occur in the
  #   time interval
  def self.get_data(id, start_time, end_time)
    all_task = Query.data.get_tasks_to_person(id)
    tasks = {
      :during => collect_tasks_during(start_time, end_time, all_task),
      :over => collect_tasks_over(start_time, end_time, all_task),
      :into => collect_tasks_into(start_time, end_time, all_task),
      :beyond => collect_tasks_beyond(start_time, end_time, all_task)
    }

    return tasks
  end

  # method to retrieve the worktime for a person for the given year and week
  # @param [Integer] id the id of the person
  # @param [Integer] year the requested year
  # @param [Integer] calendar_week the requested week of the year
  def self.get_weekly_worktime(id, start_time, end_time)
    get_interval_worktime(id, start_time, end_time, (7*24))
  end

  # method to retrieve the worktime for a person for the given year and month
  # @param [Integer] id the id of the person
  # @param [Integer] year the requested year
  # @param [Integer] month the requested month
  def self.get_monthly_worktime(id, start_time, end_time)
    days_in_month = Time.days_in_month(start_time.year,start_time.month)
    get_interval_worktime(id, start_time, end_time, (days_in_month * 24))
  end

  # method to retrieve the worktime for a person for the given time
  # interval
  def self.get_time_worktime(id, start_time, end_time)
    get_interval_worktime(id, start_time, end_time,
                          (end_time - start_time) / 60 / 60)
  end

  # singleton method to initialize the data repository with the provided data
  # @param [DataRepository] data the created database
  def self.initialize_repository(data)
    @data = data
  end

  private_class_method
  # method to calculate the work time in the given time period
  # @param [Integer] id the id of the person
  # @param [Hash] boundaries a hash containing the start and end time of the
  #   requested time interval
  # @param [Integer] time_frame the time of the interval in hours
  # @return [Hash] a hash containing all time values for the considered
  #   intervals
  def self.get_interval_worktime(id, start_time, end_time, time_frame)
    tasks = get_data(id, start_time, end_time)
    times = {
      :during => get_hours_during(tasks[:during]),
      :over => (tasks[:over].size > 0 ? time_frame : 0),
      :into => get_hours_into(tasks[:into], start_time),
      :beyond => get_hours_beyond(tasks[:beyond], end_time)
    }

    return times
  end

  private_class_method
  # method to collect all task that occur during the time interval
  # @param [Hash] date_values a hash containing the start time and the
  #   end time of the requested time interval
  # @param [Array] all_task the task with start and/ or end within the
  #   requested time interval
  # @return [Hash] all tasks taking place during the given time frame
  def self.collect_tasks_during(start_time, end_time, all_task)
    all_task.select { |task|
      !task_starts_before?(task, start_time) &&
      !task_ends_after?(task, end_time)
    }
  end

  private_class_method
  # method to collect all task that start before the time interval but do
  # not end in the time interval
  # @param [Hash] date_values a hash containing the start time and the
  #   end time of the requested time interval
  # @param [Array] all_task the task with start and/ or end within the
  #   requested time interval
  # @return [Hash] all tasks running over the given time frame
  def self.collect_tasks_over(start_time, end_time, all_task)
    all_task.select { |task|
      task_starts_before?(task, start_time) &&
      task_ends_after?(task, end_time)
    }
  end

  private_class_method
  # method to collect all task that end in the time interval but were
  # started before the requested interval
  # @param [Hash] date_values a hash containing the start time and the
  #   end time of the requested time interval
  # @param [Array] all_task the task with start and/ or end within the
  #   requested time interval
  # @return [Hash] all tasks ending in the given time frame
  def self.collect_tasks_into(start_time, end_time, all_task)
    all_task.select { |task|
      task_starts_before?(task, start_time) &&
      time_lies_in_interval?(task.end_time, start_time, end_time)
    }
  end

  private_class_method
  # method to collect all task that start in the time interval but do not
  # end in the requested interval
  # @param [Hash] date_values a hash containing the start time and the
  #   end time of the requested time interval
  # @param [Array] all_task the task with start and/ or end within the
  #   requested time interval
  # @return [Hash] all tasks starting in the given time frame
  def self.collect_tasks_beyond(start_time, end_time, all_task)
    all_task.select { |task|
      time_lies_in_interval?(task.start_time, start_time, end_time) &&
      task_ends_after?(task, end_time)
    }
  end

  private_class_method
  # method to determine if the point in time lies within the time interval
  # given by the data values
  # @param [Time] time the given point in time
  # @param [Hash] date_values two points in time creating a time interval
  # @return [Boolean] true: if time lies within the interval, false: if not
  def self.time_lies_in_interval?(time, start_time, end_time)
    time > start_time && time < end_time
  end

  private_class_method
  # method to check if a given task starts before the specified date
  # @param [Task] task the given task
  # @param [Time] date_value the considered point in time
  # @return [Boolean] true: if the task starts before the given point in time
  #   false: if not
  def self.task_starts_before?(task, date_value)
    task.start_time < date_value
  end

  private_class_method
  # method to check if a given task ends after the specified date
  # @param [Task] task the given task
  # @param [Time] date_value the considered point in time
  # @return [Boolean] true: if the task ends after the given point in time
  #   false: if not
  def self.task_ends_after?(task, date_value)
    task.end_time > date_value
  end

  private_class_method
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

  private_class_method
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

  private_class_method
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
