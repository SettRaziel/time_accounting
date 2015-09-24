# @Author: Benjamin Held
# @Date:   2015-08-24 13:32:00
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-09-24 13:34:38

require 'date'

# Extension of the ruby Time class to provide necessary operations on a {Time}
# object
class Time

  # determines the start of the next month, based on the actual value
  # @return [Time] a new {Time} object stating the first day of the next month
  def next_month
    return Time.new(year, month + 1) if (month < 12)
    return Time.new(year+1, 1)        if (month == 12)
  end

  # singleton method to determine the number of days for the actual
  # month and year
  # @param [Integer] year the considered year
  # @param [Integer] month the considered month
  # @return [Integer] the required day of the month
  def self.days_in_month(year, month)
    Date.new(year, month, -1).day
  end

  # determines the day of the week, with a week starting on monday and ending on
  # sunday and values in [0,6]
  #   monday == 0
  #   ...
  #   sunday == 6
  # @return [Integer] the week day of the actual {Time} object
  def get_int_wday
    int_wday = self.wday - 1
    return int_wday if (int_wday >= 0)
    return 6
  end

end
