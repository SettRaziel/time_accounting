# @Author: Benjamin Held
# @Date:   2016-02-17 16:39:45
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-03-09 19:27:13

module Input

  # singleton class to process the queries of {Person}s and {Task}s
  class EntityQueries < Base

    # main entry point to start a query on a person or task
    def self.entity_query_menu
      print_menu('Input (1-4): ')
    end

    private

    # method to print the available menu entries
    def self.print_menu_items
      puts 'Person and Task Queries'
      puts ' (1) Query person.'
      puts ' (2) Query task.'
      puts ' (3) Query tasks to person.'
      puts ' (4) Query persons,'
      puts ' (5) Return to previous menu.'
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    # @return [Boolean] true: if the a query type was used,
    #    false: if the script should return to the previous menu
    def self.process_input(input)
      case input
        when 1 then query_person
        when 2 then query_task
        when 3 then query_tasks_to_person
        when 4 then query_all_persons
        when 5 then return false
      else
        puts "Error: #{input} ist not valid.".red
      end
      return true
    end

    # method to query a person from the database by id
    # @raise [NoMethodError] if no person can be found by the given id
    def self.query_person
      begin
        id = get_entry("Enter id: ").to_i
        p = Input.data_handler.repository.find_person_by_id(id)
        puts "Result: #{p.to_string}\n\n"
      rescue NoMethodError => e
        puts "Could not found person with id #{id}.".red
      end
    end

    # method to query all persons of the database
    def self.query_all_persons
      persons = Input.data_handler.repository.get_persons
      persons.each { |person|
        puts person.to_string
      }
    end

    # method to query a task from the database by its id
    def self.query_task
      result = Hash.new()
      id = get_entry("Enter id: ").to_i
      tasks = Input.data_handler.repository.repository
      tasks.each_pair { |key, task_list|
        task_list.each { |task|
          result[task] = key if (task.id == id)
        }
      }

      puts "#{result.keys.size} tasks found.".yellow
      result.each_pair { |key, value|
        puts "  Found task: #{key.to_string} for\n  #{value.to_string}"
      }
      puts
    end

    # method to query all tasks belonging to a specified person
    def self.query_tasks_to_person
      begin
        id = get_entry("Enter id: ").to_i
        t = Input.data_handler.repository.get_tasks_to_person(id)
        puts "#{t.size} tasks found".yellow
        t.each { |task|
          puts task.to_string
        }
        puts
      rescue NoMethodError => e
        puts "Could not found person with id #{id}.".red
      end
    end

  end

end
