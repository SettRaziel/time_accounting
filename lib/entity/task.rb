# @Author: Benjamin Held
# @Date:   2015-08-21 13:00:30
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-10-03 15:22:45

# This module holds the classes that are use for creating a {Task}.
module Task

  require_relative '../output/string'
  require 'time'

  # This class represents a work task. A task gets a unique id from its
  # {TaskIDGenerator}. Similar to the {Person}, the task holds a method
  # {#to_string} for terminal output and {#to_file} for file output.
  # Corresponding to the mechanism to read stored data (see {FileReader}) the
  # Task also holds {Task.create_from_attribute_list} to create a new object
  # from an Array of Strings.
  class Task
    # @return [Time] the start date of the task
    attr_reader :start_time
    # @return [Time] the end date of the task
    attr_reader :end_time
    # @return [Integer] the unique id of the task
    attr_reader :id
    # @return [String] the description of the task
    attr_reader :description

    # initialization
    # @param [Integer] id the unique id of the task
    # @param [Time] start_time the start date
    # @param [Time] end_time the end date
    # @param [String] description the description of the task
    def initialize(id=TaskIDGenerator.generate_new_id, start_time, end_time,
                   description)
      @id = id
      @start_time = start_time
      @end_time = end_time
      @description = description
    end

    # creates an output string with the attributes
    # timeformat: http://ruby-doc.org/core-2.2.0/Time.html#method-i-subsec
    # @return [String] output string for this task
    def to_string
      "Task: #{@description} \n with ID: #{@id} started at " \
      "#{@start_time.strftime("%F %R")} and was finished at " \
      "#{@end_time.strftime("%F %R")}."
    end

    # creates an output string for the storage in a file. The format servers the
    # output format of the output file
    # @return [String] a string coding all information of the task for storage
    # @see FileWriter informations of output format
    def to_file
      start_str = @start_time.iso8601
      end_str = @end_time.iso8601
      "#{@id};#{@description};#{start_str};#{end_str}"
    end

    # singleton method to create a {Task} from a list
    # @param [Array] list list of string attributes to create a person
    # @return [Task] a task initialized with the content of the given list
    def self.create_from_attribute_list(list)
      check_list_size(list)

      start_time = Time.strptime(list[2], "%FT%T%z")
      end_time = Time.strptime(list[3], "%FT%T%z")
      self.new(list[0].to_i, start_time, end_time, list[1])
    end

    private_class_method
    # singleton method to check for the correct list size
    # @param [Array] list with attributes
    # @raise [ArgumentError] if the size of the list does not fit the number of
    #   required attributes
    def self.check_list_size(list)
      if (list.size != 4)
        raise ArgumentError,
        ' Error: list contains wrong number of arguments to create a task.'.red
      end
    end

  end

  # singleton class to serve as an id generator for {Task}.
  class TaskIDGenerator
    # @return [Fixnum] the current id
    @@id = 0

    # initialization
    # @param [Fixnum] id the start id
    def initialize(id)
      @@id = id
    end

    # generates a new id and returns it
    # @return [Fixnum] new id
    def self.generate_new_id
      @@id += 1
    end
  end

end
