# @Author: Benjamin Held
# @Date:   2015-08-24 12:43:15
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-02-01 17:27:28

require_relative '../handler/data_handler'
require_relative '../query/query'
require_relative '../output/string'

module Menu

  # dummy class to get access to the data handler within the module
  class << self
    # @return [BaseHandler] the handler for the data storage
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

  require_relative 'base_menu'
  require_relative 'adapter_menu'
  require_relative 'database_option'
  require_relative 'main_menu'
  require_relative 'person_option'
  require_relative 'entity_addition'
  require_relative 'entity_queries'
  require_relative './worktime/worktime_queries'

end
