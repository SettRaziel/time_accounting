# @Author: Benjamin Held
# @Date:   2016-04-18 15:41:13
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-05-04 17:48:59

require 'csv'
require_relative 'attribute_string_factory'

class CSVWriter

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

  def self.write(filename, output)
    CSV.open(filename, "wb", {:col_sep => ";"}) { |csv|
      output.each { |entry|
        csv << entry.split(';')
      }
    }
  end

end
