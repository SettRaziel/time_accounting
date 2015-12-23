# @Author: Benjamin Held
# @Date:   2015-08-24 12:53:57
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-23 22:33:19

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
