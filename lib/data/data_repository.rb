# @Author: Benjamin Held
# @Date:   2015-08-20 11:23:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-05 12:42:57

require_relative '../entity/person/person'
require_relative '../entity/task'
require_relative '../output/string'

# This class serves as a data repository mapping {Person} => {Task}. A {Person}
# can be the parent class {Person} or any of its children. To ensure the
# correct addition of a {Person} they should be add via {#add_person}.
# Persons can be looked up with the object in the hash or by its person id.
# The {Task} of a {Person} can be found by {#get_tasks_to_person} with an id.
class DataRepository
  # @return [Hash] the repository mapping {Person} => {Task}
  attr :repository
  # @return [Integer] the highest person id from {#set_max_ids}
  attr_reader :max_person_id
  # @return [Integer] the highest task id from {#set_max_ids}
  attr_reader :max_task_id

  # initialization
  def initialize
    @repository = Hash.new()
    @max_person_id = 0
    @max_task_id = 0
  end

  # adds a person to the repository and also checks for duplicated entries
  # @param [Person] person the person that should be added
  # @raise [IndexError] if a person with this id already exists
  def add_person(person)
    if (check_for_unique_id(person))
      repository[person] = Array.new()
    else
      raise IndexError, " Error: duplicated id found: #{person.id}, " \
                        " #{person.name} cannot be added.".red
    end
  end

  # assigns a task to the provided person id
  # @param [Integer] person_id the id of the person which should get the task
  # @param [Task] task the task that should be assigned
  # @raise [ArgumentError] if no person could be found to the given id
  def add_task_to_person(person_id, task)
    person = find_person_by_id(person_id)
    if (person != nil)
      repository[person] << task
    else
      raise ArgumentError, " Error: id #{person_id} was not found.".red
    end
  end

  # query to find a person by the given id
  # @param [Integer] person_id the id of the searched person
  # @return [Person | nil] the person if found or nil
  def find_person_by_id(person_id)
    repository.each_key { |key|
      return key if (key.id == person_id)
    }

    return nil
  end

  # query to find all tasks to a person specified by its id
  # @param [Integer] person_id the id of the searched person
  # @return [Array | nil] the tasks of the person or nil if the person was not
  #   found
  def get_tasks_to_person(person_id)
    person = find_person_by_id(person_id)
    puts " Warning: person for id #{person_id} not found." if (person == nil)
    repository[person]
  end

  # sets the start values for the two id generators
  # @param [Array] ids the two generator values
  # @raise [ArgumentError] if one of the id values is <= 0
  def set_max_ids(ids)
    if (ids[0] > 0)
      @max_person_id = ids[0]
    else
      raise ArgumentError, "Error: given person id #{max_person_id} <= 0".red
    end
    if (ids[1] > 0)
      @max_task_id = ids[1]
    else
      raise ArgumentError, "Error: given person id #{max_task_id} <= 0".red
    end
  end

  private

  # method to check if the person already exists
  # @param [Person] person the person that should be checked
  # @return [boolean] true, if not in the list, false, if in the list
  def check_for_unique_id(person)
    find_person_by_id(person.id) == nil
  end

end
