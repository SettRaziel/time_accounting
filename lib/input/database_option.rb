# @Author: Benjamin Held
# @Date:   2015-08-27 12:21:25
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-11 12:35:20

module Input

  # This class holds the menu for query options regarding person and task query
  # and the addition of people or tasks
  class DatabaseOption

    require_relative '../query/query'

    # main entry point, this method gets the {DataHandler} from the {MainMenu}
    # to work on the repository and to initiate the save operation
    # @param [DataHandler] data_handler the data handler created by the
    #  commands of the main menu
    def self.database_menu
      Query.initialize_repository(Input.data_handler.repository)
      while (true)
        begin
          print_menu
          input = get_entry("Input (1-7): ").to_i

          process_input(input)
        rescue StandardError => e
          puts "Error in DatabaseOption: ".concat(e.message).red
        end
      end
    end

    private

    # method to print the available menu entries
    def self.print_menu
      puts "\nDatabase options"
      puts " (1) Add person."
      puts " (2) Add task."
      puts " (3) Query person."
      puts " (4) Query task."
      puts " (5) Query tasks to person."
      puts " (6) Save and exit."
      puts " (7) Abort and exit."
    end

    # method to process the provided input
    # @param [Integer] input the provided input
    def self.process_input(input)
      case input
        when 1 then add_person
        when 2 then add_task
        when 3 then query_person
        when 4 then query_task
        when 5 then query_tasks_to_person
        when 6 then save_and_exit
        when 7 then Input.exit_script
      else
        puts "Error: #{input} ist not valid.".red
      end
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
      start_time = parse_date(
                get_entry("Enter start date (format: YYYY-MM-DD-hh:mm): "))
      end_time = parse_date(
                get_entry("Enter end date (format: YYYY-MM-DD-hh:mm): "))
      description = get_entry("Enter description: ")

      Task::Task.new(start_time, end_time, description)
    end

    # method to parse a date from a given string
    # @param [String] string the string with the data
    # @return [Time] the newly created tme object
    def self.parse_date(string)
      time = string.split("-")
      Time.new(time[0], time[1], time[2],time[3],time[4])
    end

    # method to query a person from the database by id
    # @raise [NoMethodError] if no person can be found by the given id
    def self.query_person
      begin
        id = get_entry("Enter id: ").to_i
        p = Input.data_handler.repository.find_person_by_id(id)
        puts "Result: #{p.to_string}"
      rescue NoMethodError => e
        raise e.class, "Could not found person with id #{id}.".red
      end
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
      rescue NoMethodError => e
        raise e.class, "Could not found person with id #{id}. #{e.message}".red
      end
    end

    # method to save the current repository and exit the script
    def self.save_and_exit
      begin
        Input.data_handler.save_repository
        Input.exit_script
      rescue IOError => e
        raise IOError, "Error while saving data: ".concat(e.message).red
      end
    end

    # method to print a given message and read the provided input
    # @param [String] message output message
    # @return [String] the input from the terminal
    def self.get_entry(message)
      print message.blue.bright
      gets.chomp
    end

  end

end
