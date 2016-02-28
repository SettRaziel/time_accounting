# @Author: Benjamin Held
# @Date:   2015-08-24 12:43:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-28 15:10:32

# This module holds the classes for the terminal menu, which can be used to
# run this program in a terminal window
module Input

  require_relative '../handler/data_handler'
  require_relative '../output/string'

  class << self
    attr_reader :data_handler
  end

  # method to set a new data handler
  # @param [DataHandler] data_handler the given data handler
  def self.initialize_datahandler(data_handler)
    @data_handler = data_handler
  end

  # method to end the script without saving any data
  def self.exit_script
    puts "Shutting down...".yellow
    exit(0)
  end

  # method to parse a date from a given string
  # @param [String] string the string with the data
  # @return [Time] the newly created tme object
  def self.parse_date(string)
    time = string.split("-")
    Time.new(time[0], time[1], time[2],time[3],time[4])
  end

end

require_relative 'database_option'
require_relative 'main_menu'
require_relative 'person_option'
require_relative 'entity_addition'
require_relative 'entity_queries'
require_relative 'worktime_queries'
