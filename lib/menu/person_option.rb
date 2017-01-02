# @Author: Benjamin Held
# @Date:   2015-08-27 12:48:05
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-02 19:00:53

module Menu

  # menu class to process the add option for persons
  class PersonOption < Base

    # initialization
    def initialize
      super
      @menu_description = 'Adds a new Person. Select Type: '
    end

    # public entry point to print the menu and execute to chosen option
    def add_person
      print_menu
    end

    private

    # method to define all printable menu items
    def define_menu_items
      add_menu_item('Person.', 1)
      add_menu_item('Student.', 2)
      add_menu_item('Cancel and return to previous menu.', 3)
    end

    # method to process the provided input
    # @param [String] input the provided input
    # @return [Boolean] true: if the program should continue,
    #    false: if the script should return to the previous menu
    def determine_action(input)
      case (input.to_i)
        when 1 then add_simple_person
        when 2 then add_student
        when 3 then return false
      else
        handle_wrong_option
      end
      return true
    end

    # method to create and add a simple person
    def add_simple_person
      name = get_entry('Enter name: ')

      p = Person::Person.new(name)
      Menu.data_handler.add_person(p)
      puts "Person with id #{p.id} added successfully.".green
    end

    # method to create and add a student
    def add_student
      name = get_entry('Enter name: ')
      mat_nr = get_entry('Enter matriculation number: ').to_i

      s = Person::Student.new(name, mat_nr)
      Menu.data_handler.add_person(s)
      puts "Student with id #{s.id} added successfully.".green
    end

  end

end
