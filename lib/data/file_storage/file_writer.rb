# @Author: Benjamin Held
# @Date:   2015-08-23 14:18:48
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-04-21 14:34:23

require_relative '../../entity/person/person'
require_relative '../../entity/task'
require_relative '../data_repository'

# This class stores the {Person}s and {Task}s of a {DataRepository} into a file
# specified by {#filename}. The {FileWriter} stores the data in the following
# format:
#   Persons <
#   Person::Type {
#   parameter1;...;parameterN
#   }
#   Person::Type {
#   parameter1;...;parameterN
#   }
#   >
#   Tasks <
#   person_id {
#   parameter1;...;parameterN
#   }
#   person_id {
#   parameter1;...;parameterN
#   }
#   >
class FileWriter
  # @return [String] the filename of the output file
  attr_reader :filename

  # initialization
  # @param [String] filename the filename of the output file
  def initialize(filename='default_file')
    @filename = filename
  end

  # method to store a list of {Person}s in the file
  # @param [Array] person_list the list of persons
  def write_all_persons(person_list)
    output = File.new(filename, 'w')

    output.puts 'Persons <'
    person_list.each { |person|
      output.puts "#{person.class} {"
      output.puts person.to_file
      output.puts '}'
    }
    output.puts ">"

    output.close
  end

  # method to store a the {Task}s in the file
  # @param [DataRepository] repository the used {DataRepository}
  def write_all_tasks(repository)
    output = File.new(filename, 'a')

    output.puts 'Tasks <'
    repository.each_pair { |key, value|
      key_id = key.id
      value.each { |task|
        output.puts "#{key_id} {"
        output.puts task.to_file
        output.puts '}'
      }
    }
    output.print '>'

    output.close
  end

end
