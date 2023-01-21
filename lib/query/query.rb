# This module holds the classes and methods for queries regarding the data
module Query

  require_relative '../entity/time'

  # dummy class to get access to the data from methods within the module
  class << self
    # @return [BaseHandler] the database with the {Task}s and {Person}s
    attr :data
  end

  # method to collect all tasks of a person in a given time interval
  # @param [Integer] id the id of the person
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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

  # method to retrieve the worktime for a person for the given week
  # @param [Integer] id the id of the person
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
  # @return [Hash] a hash containing all time values for the considered
  #   intervals
  def self.get_weekly_worktime(id, start_time, end_time)
    tasks = get_data(id, start_time, end_time)
    TimeAccumulator.get_interval_worktime(tasks, start_time, end_time, (7*24))
  end

  # method to retrieve the worktime for a person for the given month
  # @param [Integer] id the id of the person
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
  # @return [Hash] a hash containing all time values for the considered
  #   intervals
  def self.get_monthly_worktime(id, start_time, end_time)
    days_in_month = Time.days_in_month(start_time.year,start_time.month)
    tasks = get_data(id, start_time, end_time)
    TimeAccumulator.get_interval_worktime(tasks, start_time, end_time,
                                          (days_in_month * 24))
  end

  # method to retrieve the worktime for a person for the given time
  # interval
  # @param [Integer] id the id of the person
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
  # @return [Hash] a hash containing all time values for the considered
  #   intervals
  def self.get_time_worktime(id, start_time, end_time)
    tasks = get_data(id, start_time, end_time)
    TimeAccumulator.get_interval_worktime(tasks, start_time, end_time,
                                         (end_time - start_time) / 60 / 60)
  end

  # singleton method to initialize the data repository with the provided data
  # @param [DataRepository] data the created database
  def self.initialize_repository(data)
    @data = data
  end

  private_class_method
  # method to collect all task that occur during the time interval
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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
  # @param [Time] start_time the start time of the time interval
  # @param [Time] end_time the end time of the time interval
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

end

require_relative 'time_accumulator'
