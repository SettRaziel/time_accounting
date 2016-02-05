# @Author: Benjamin Held
# @Date:   2015-08-21 13:00:30
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-05 12:44:48

module Task

  require_relative '../output/string'

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
    # @return [String] output string for this task
    def to_string
      # todo time format http://ruby-doc.org/core-2.2.0/Time.html#method-i-subsec
      "Task: #{@description} \n with ID: #{@id} started " \
      "#{@start_time.strftime("%F %R")} and was finished " \
      "#{@end_time.strftime("%F %R")}"
    end

    # creates an output string for the storage in a file. The format servers the
    # output format of the output file
    # @see FileWriter informations of output format
    def to_file
      start_str = @start_time.strftime("%Y;%m;%d;%H;%M;%S;%:z")
      end_str = @end_time.strftime("%Y;%m;%d;%H;%M;%S;%:z")
      "#{@id};#{start_str};#{end_str};#{@description}"
    end

    # singleton method to create a {Task} from a list
    # @param [Array] list list of string attributes to create a person
    def self.create_from_attribute_list(list)
      check_list_size(list)

      start_time = create_time_object(list, 1)
      end_time = create_time_object(list, 8)
      self.new(list[0].to_i, start_time, end_time, list[15])
    end

    private

    # singleton method to check for the correct list size
    # @param [Array] list with attributes
    # @raise [ArgumentError] if the size of the list does not fit the number of
    #   required attributes
    def self.check_list_size(list)
      if (list.size != 16)
        raise ArgumentError,
        ' Error: list contains wrong number of arguments to create a task.'.red
      end
    end

    # singleton method to create a {Time} object from the list starting at
    # the provided index
    # @param [Array] list list from which the object should be created
    # @param [Integer] start_index start array index
    # @return [Time] the desired time object
    def self.create_time_object(list, start_index)
      Time.new(list[start_index].to_i,
               list[start_index + 1].to_i,
               list[start_index + 2].to_i,
               list[start_index + 3].to_i,
               list[start_index + 4].to_i,
               list[start_index + 5].to_i,
               list[start_index + 6])
    end

  end

  # singleton class to serve as an id generator for {Task}.
  class TaskIDGenerator
    # @return [Fixnum] the current id
    @@id

    # initialization
    # @param [Fixnum] id the start id
    def initialize(id=0)
      @@id = id
    end

    # generates a new id and returns it
    # @return [Fixnum] new id
    def self.generate_new_id
      @@id += 1
    end
  end

end
