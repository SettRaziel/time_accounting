# @Author: Benjamin Held
# @Date:   2016-04-18 15:41:13
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-05-08 15:00:08

require 'csv'
require_relative 'attribute_string_factory'

# Singleton class to write the provided output in a csv-formatted file
class CSVWriter

  # public entry point to create the csv file
  # @param [String] filename the path of the output file
  # @param [Person] person the person whose tasks should be written
  # @param [Array] tasks the result tasks
  # @param [Array] additions additonal lines which should follow the tasks in
  #    the csv output
  def self.output(filename, person, tasks, additions)
    output = Array.new()

    output << AttributeStringFactory.get_attributes_to_person(person)
    output << person.to_file

    output << String.new()

    output << AttributeStringFactory.get_attributes_to_task
    tasks.each { |task|
      output << task.to_file
    }

    output << String.new()
    additions.each { |entry|
      output << entry
    }
    write(filename, output)
  end

  private

  # method to print the output into the file
  # @param [String] filename the path of the output file
  # @param [Array] output the prepared output lines
  def self.write(filename, output)
    CSV.open(filename, "wb", {:col_sep => ";"}) { |csv|
      output.each { |entry|
        csv << entry.split(';')
      }
    }
  end

end
