require_relative "../../entity/person/person"
require_relative "../../entity/task"
require_relative "./data_repository"

# This class reads {Person}s and {Task}s from a file specified by the provided
# filename. For a successful reading process the file need to fit the format
# specified in the {FileWriter}
# @see FileWriter file format description
class FileReader

  # singleton method to read a file specified by filename
  # @param [String] filename the file name of the requested file
  def self.read_file(filename)
    input = File.open(filename, "r")
    repo = DataRepository.new()
    ids = Array.new()

    while(line = input.gets && !line =~ /Persons </); end
    ids << read_all_persons(input, repo)

    while(line = input.gets && !line =~ /Tasks </); end
    ids << read_all_tasks(input, repo)

    repo.set_max_ids(ids)

    return repo
  end

  private_class_method
  # method to read all persons from the file and store them in the
  # {DataRepository}
  # @param [File] input the content of the file
  # @param [DataRepository] repo the used {DataRepository}
  # @return [Integer] the highest person id
  def self.read_all_persons(input, repo)
    max_person_id = 0
    while (line = input.gets)
      break if (line =~ />/)
      type = line.split(" ")[0].split("::").inject(Object) {|o,c|
        o.const_get c
      }
      p = type.create_from_attribute_list(input.gets.chomp.split(";"))
      max_person_id = p.id if (p.id > max_person_id)
      repo.add_person(p)
      input.gets # removes closing } from a person
    end

    return max_person_id
  end

  private_class_method
  # method to read all tasks from the file and store them in the
  # {DataRepository}
  # @param [File] input the content of the file
  # @param [DataRepository] repo the used {DataRepository}
  # @return [Integer] the highest task id
  def self.read_all_tasks(input, repo)
    max_task_id = 0
    while (line = input.gets)
      break if (line =~ />/)
      id = line.split(" ")[0].to_i

      t = Task::Task.create_from_attribute_list(input.gets.chomp.split(";"))
      max_task_id = t.id if (t.id > max_task_id)
      repo.add_task_to_person(id,t)
      input.gets # removes closing } from a task
    end

    return max_task_id
  end

end
