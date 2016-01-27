# @Author: Benjamin Held
# @Date:   2015-08-24 13:15:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-27 14:38:19

module Query

  # statistic class to calculate to work time for a given month and year
  class MonthQuery < Base

    # method to retrieve the worktime for a person for the given year and month
    # @param [Integer] id the id of the person
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    def self.get_monthly_worktime(id, year, month)
      months = calculate_month_and_next_month(year, month)
      get_interval_worktime(id, months, (Time.days_in_month(year,month) * 24))
    end

    # method to calculate the time boundaries for the given month
    # @param [Integer] year the requested year
    # @param [Integer] month the requested month
    # @return [Hash] a hash containing the two time boundaries
    def self.calculate_month_and_next_month(year, month)
      check_date = Time.new(year, month)
      {:actual => check_date, :next => check_date.next_month}
    end

  end

end
