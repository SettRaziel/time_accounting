# @Author: Benjamin Held
# @Date:   2016-02-18 18:18:17
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-19 16:16:59

module Input

  # singleton class to process the addition of {Person}s and {Task}s
  class EntityAddition < Base

    # main entry point to start the addition of a person or task
    def self.entity_addition_menu
      print_menu('Input (1-3): ')
    end

    private

    # method to print the available menu entries
    def self.print_menu_items
      puts 'Person and Task Addition'
      puts ' (1) Add person.'
      puts ' (2) Add task.'
      puts ' (3) Cancel and return to previous menu.'
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    # @return [Boolean] true: if the a query type was used,
    #    false: if the script should return to the previous menu
    def self.process_input(input)
      case input
        when 1 then add_person
        when 2 then add_task
        when 3 then return false
      else
        puts "Error: #{input} ist not valid.".red
      end
      return true
    end

    # method to start the addition of a person by the {PersonOption}
    def self.add_person
      PersonOption.add_person
    end

    # method to add a new {Task} defined by the users console input
    def self.add_task
      t = create_task_from_input

      puts "Task with id #{t.id} created successfully.".green
      person_id =
          get_entry("Enter id of the person who should take the task: ").to_i
      Input.data_handler.repository.add_task_to_person(person_id, t)
      puts "Task with id #{t.id} added to person with id #{person_id}.".green
    end

    # method to create a task from the provided input
    # @return [Task] the new task based on the input
    def self.create_task_from_input
      start_time = Input.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = Input.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      description = get_entry("Enter description: ")

      Task::Task.new(start_time, end_time, description)
    end

  end

end
