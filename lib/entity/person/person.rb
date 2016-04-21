# @Author: Benjamin Held
# @Date:   2015-08-20 11:28:16
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-21 14:33:25

# This module holds the classes describing a Person or a special form of
# person with additional attributs to the basic name and id of a {Person}.
module Person

  require_relative '../../output/string'

  # This class provides the basis for describing a person entity. When providing
  # an {#id} it is uses as the identification number. If no value is provided
  # the {#id} will be created by the {PersonIDGenerator}. Every child class
  # should overwrite the method {#to_string} and {#to_file} to provide a output
  # string for the terminal and the file with all of its attributes.
  # In addition it should implement a method {.create_from_attribute_list} to
  # provide creation of an object via an Array of strings. The method is used,
  # when objects are loaded from a file.
  class Person
    # @return [String] the name of a person
    attr_reader :name
    # @return [Fixnum] the id of a person
    attr_reader :id

    # initialization
    # @param [String] name the name of the person
    # @param [Integer] id the unique id of a person
    def initialize(name="no_name", id=PersonIDGenerator.generate_new_id)
      @id = id
      @name = name
    end

    # creates an output string with the attributes
    # @return [String] output string for this person
    def to_string
      "Person: #{@name} with ID: #{@id}"
    end

    # creates an output string for the storage in a file. The format serves the
    # output format of the output file
    # @return [String] a string coding all information of the person for storage
    # @see FileWriter informations of output format
    def to_file
      "#{@name};#{@id}"
    end

    # singleton method to create a {Person} from an array of strings
    # @param [Array] list list of string attributes to create a person
    # @raise [ArgumentError] if the size of the list does not fit the number of
    #   required attributes
    def self.create_from_attribute_list(list)
      if (list.size != 2)
        raise ArgumentError,
              ' Error: list contains wrong number of arguments to create' \
              ' a person.'.red
      end
      id = list[1].to_i
      self.new(list[0], id)
    end
  end

  # singleton class to serve as an id generator for {Person} and their children.
  class PersonIDGenerator
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

require_relative 'student'
