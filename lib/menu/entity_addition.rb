# @Author: Benjamin Held
# @Date:   2016-02-18 18:18:17
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-28 13:02:06

module Menu

  # singleton class to process the addition of {Person}s and {Task}s
  class EntityAddition < Base

    # initialization
    def initialize
      super
      @menu_description = 'Person and Task Addition'
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('Add person.', 1)
      add_menu_item('Add task.', 2)
      add_menu_item('Cancel and return to previous menu.', 3)
      nil
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should return to the previous menu
    def determine_action(input)
      case (input.to_i)
        when 1 then add_person
        when 2 then add_task
        when 3 then return false
      else
        handle_wrong_option
      end
      return true
    end

    # method to start the addition of a person by the {PersonOption}
    def add_person
      PersonOption.new.add_person
      nil
    end

    # method to add a new {Task} defined by the users console input
    def add_task
      t = create_task_from_input

      puts "Task with id #{t.id} created successfully.".green
      person_id =
          get_entry("Enter id of the person who should take the task: ").to_i
      Menu.data_handler.add_task_to_person(person_id, t)
      puts "Task with id #{t.id} added to person with id #{person_id}.".green
      nil
    end

    # method to create a task from the provided input
    # @return [Task] the new task based on the input
    def create_task_from_input
      start_time = Menu.parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = Menu.parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      description = get_entry("Enter description: ")

      Task::Task.new(start_time, end_time, description)
    end

  end

end
