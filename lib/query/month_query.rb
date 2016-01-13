# @Author: Benjamin Held
# @Date:   2015-08-24 13:15:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-13 08:56:26

require_relative '../entity/time'

module Query

  # statistic class to calculate to work time for a given month and year
  class MonthQuery < Base

    # method to retrieve the worktime for a person for the given year and month
    # @param [Integer] id the id of the person
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    def self.get_monthly_worktime(id, year, month)
      get_interval_worktime(id, year, month,
                           (Time.days_in_month(year,month) * 24))
    end

    private

    # method to calculate the time boundaries for the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @return [Hash] a hash containing the two time boundaries
    def self.calculate_month_and_next_month(year, month)
      check_date = Time.new(year, month)
      {:actual => check_date, :next => check_date.next_month}
    end

    # method to get all tasks taking place during the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_during(year, month, all_task)
      months = calculate_month_and_next_month(year, month)
      collect_tasks_during(months, all_task)
    end

    # method to get all tasks taking place throughout the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_over(year, month, all_task)
      months = calculate_month_and_next_month(year, month)
      collect_tasks_over(months, all_task)
    end

    # method to get all tasks starting before the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_into(year, month, all_task)
      months = calculate_month_and_next_month(year, month)
      collect_tasks_into(months, all_task)
    end

    # method to get all tasks ending after the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @param [Array] all_task the tasks of the requested person
    # @return [Array] an array containing the collected tasks
    def self.get_tasks_beyond(year, month, all_task)
      months = calculate_month_and_next_month(year, month)
      collect_tasks_beyond(months, all_task)
    end

    # method to calculate the worktime within the month for tasks starting
    # before the requested month
    # @param [Array] tasks the tasks starting before the requested month for
    #    the requested person
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @return [Float] the working time for these tasks within the requested
    #    month in hours
    def self.get_hours_into(tasks, year, month)
      month = Time.new(year, month)
      get_into_value(tasks, month)
    end

    # method to calculate the worktime within the month for tasks ending
    # after the requested month
    # @param [Array] tasks the tasks ending after the requested month for
    #    the requested person
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @return [Float] the working time for these tasks within the requested
    #    month in hours
    def self.get_hours_beyond(tasks, year, month)
      next_month = Time.new(year, month).next_month
      get_beyond_value(tasks, next_month)
    end

  end

end
