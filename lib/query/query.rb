# @Author: Benjamin Held
# @Date:   2015-08-24 12:53:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-01 09:56:39

# this module holds the classes and methods for queries regarding the data
module Query

  # dummy class to get access to the data from methods within the module
  class << self
    # @return [DataRepository] the database with the {Task}s and {Person}s
    attr :data
  end

  # This class provides the common methods of the query types. The children
  # need to implement the following methods:
  # {#get_tasks_during},
  # {#get_tasks_over},
  # {#get_tasks_into} and
  # {#get_tasks_beyond} to generate results.
  # @raise [NotImplementedError] if the mentioned methods are not implemented
  class Base

    def self.get_data(id, year, time_delta)
      all_task = Query.data.get_tasks_to_person(id)
      tasks = {
        :during => get_tasks_during(year, time_delta, all_task),
        :over => get_tasks_over(year, time_delta, all_task),
        :into => get_tasks_into(year, time_delta, all_task),
        :beyond => get_tasks_beyond(year, time_delta, all_task)
      }

      puts "tasks.during: #{tasks[:during].inspect}"
      puts "tasks.over: #{tasks[:over].inspect}"
      puts "tasks.into: #{tasks[:into].inspect}"
      puts "tasks.beyond: #{tasks[:beyond].inspect}"

      return tasks
    end

    def self.get_interval_worktime(id, year, interval, time_frame)
      tasks = get_data(id, year, interval)

      if (tasks[:over].size > 0)
        puts "Worktime: #{time_frame}"
      else
        puts "tasks.during: #{get_hours_during(tasks[:during])} h"
        puts "tasks.into: #{get_hours_into(tasks[:into], year, interval)} h"
        puts "tasks.beyond: " \
             "#{get_hours_beyond(tasks[:beyond], year, interval)} h"
      end

    end

    def self.get_hours_during(tasks)
      total = 0
      tasks.each { |task|
        total += task.end_time - task.start_time
      }

      total = (total / 3600).round(2)
    end

    def self.get_into_value(tasks, time_frame)
      total = 0
      tasks.each { |task|
        total += task.end_time - time_frame
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
    MonthQuery.get_data(id, year, month)
  end

end

require_relative 'month_query'
require_relative 'week_query'
