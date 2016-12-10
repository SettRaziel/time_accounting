# @Author: Benjamin Held
# @Date:   2016-02-17 16:39:45
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-10 18:01:46

module Menu

  # singleton class to process the queries of {Person}s and {Task}s
  class EntityQueries < Base

    # initialization
    def initialize
      super
      @menu_description = 'Person and Task Queries'
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('Query person.', 1)
      add_menu_item('Query task.', 2)
      add_menu_item('Query tasks to person.', 3)
      add_menu_item('Query persons.', 4)
      add_menu_item('Cancel and return to previous menu.', 5)
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should return to the previous menu
    def determine_action(input)
      case (input.to_i)
        when 1 then query_person
        when 2 then query_task
        when 3 then query_tasks_to_person
        when 4 then query_all_persons
        when 5 then return false
      else
        handle_wrong_option
      end
      return true
    end

    # method to query a person from the database by id
    # @raise [NoMethodError] if no person can be found by the given id
    def query_person
      begin
        id = get_entry("Enter id: ").to_i
        p = Menu.data_handler.repository.find_person_by_id(id)
        puts "Result: #{p.to_string}\n\n"
      rescue NoMethodError
        puts "Could not found person with id #{id}.".red
      end
    end

    # method to query all persons of the database
    def query_all_persons
      persons = Menu.data_handler.repository.get_persons
      persons.each { |person|
        puts person.to_string
      }
    end

    # method to query a task from the database by its id
    def query_task
      result = Hash.new()
      id = get_entry("Enter id: ").to_i
      task = Menu.data_handler.repository.find_task_to_id(id)
      puts task.to_string
    end

    # method to query all tasks belonging to a specified person
    def query_tasks_to_person
      begin
        id = get_entry("Enter id: ").to_i
        t = Menu.data_handler.repository.get_tasks_to_person(id)
        puts "#{t.size} tasks found".yellow
        t.each { |task|
          puts task.to_string
        }
        puts
      rescue NoMethodError
        puts "Could not found person with id #{id}.".red
      end
    end

  end

end
