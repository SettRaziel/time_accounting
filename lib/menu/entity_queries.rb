module Menu

  # menu class to process the queries of {Person}s and {Task}s
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
      add_menu_item('Query tasks.', 5)
      add_menu_item('Cancel and return to previous menu.', 6)
      nil
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
        when 5 then query_all_tasks
        when 6 then return false
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
        p = Menu.data_handler.find_person_by_id(id)
        puts "Result: #{p.to_string}\n\n"
      rescue NoMethodError
        puts "Could not found person with id #{id}.".red
      end
      nil
    end

    # method to query all persons of the database
    def query_all_persons
      output_results(Menu.data_handler.get_persons)
      nil
    end

    # method to query all tasks of the database
    def query_all_tasks
      output_results(Menu.data_handler.get_tasks)
      nil
    end

    # method to query a task from the database by its id
    def query_task
      id = get_entry("Enter id: ").to_i
      task = Menu.data_handler.find_task_to_id(id)
      puts task.to_string
      nil
    end

    # method to query all tasks belonging to a specified person
    def query_tasks_to_person
      begin
        id = get_entry("Enter id: ").to_i
        t = Menu.data_handler.get_tasks_to_person(id)
        puts "#{t.size} tasks found".yellow
        output_results(t)
        puts
      rescue NoMethodError
        puts "Could not found person with id #{id}.".red
      end
      nil
    end

    # method to print a given array of result entities
    # @param [Array] results the results of a given query
    def output_results(results)
      results.each { |result|
        puts result.to_string
      }
      nil
    end
  end

end
