# @Author: Benjamin Held
# @Date:   2015-08-21 12:39:13
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-21 14:33:52

module Person

  # child class from {Person} to represent a Student. The {Student} gains the
  # matriculation number {#mat_nr} in addition to the attributes from its parent
  # class.
  # @see Person additional informations about the structure of this class
  class Student < Person
    # @return [Integer] the matriculation number
    attr_reader :mat_nr

    # initialization
    # @param [String] name the name of the student
    # @param [Integer] id the unique id of a person
    # @param [Integer] mat_nr the matriculation number
    def initialize(name="def_student", id=PersonIDGenerator.generate_new_id,
                   mat_nr)
      super(name, id)
      @mat_nr = mat_nr
    end

    # overwrites the method {Person#to_string} to create an output string
    # with all its attributes
    # @return [String] output string for this student
    def to_string
      super.concat(" and Matriculation: #{@mat_nr}")
    end

    # overwrites the method {Person#to_file} to create an output string
    # for the output file with all its attributes
    # @return [String] a string coding all information of the student
    #   for storage
    def to_file
      super.concat(";#{@mat_nr}")
    end

    # singleton method to create a {Student} from a n array of strings
    # @param [Array] list list of string attributes to create a person
    # @raise [ArgumentError] if the size of the list does not fit the number of
    #   required attributes
    # @see Person.create_from_attribute_list
    def self.create_from_attribute_list(list)
      id = list[1].to_i
      mat_nr = list[2].to_i
      self.new(list[0], id, mat_nr)
    end

  end

end
