# @Author: Benjamin Held
# @Date:   2015-08-27 12:48:05
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-02-14 13:45:29

module Input

  # singleton class to process the add option for persons
  class PersonOption

    # singleton entry point to print the menu and execute to chosen option
    def self.add_person
      puts "Adds a new Person. Select Type:"
      puts " (1) Person"
      puts " (2) Student"
      puts " (3) Cancel"
      print "Input (1-3): "
      input = gets.chomp.to_i

      case input
        when 1 then add_simple_person
        when 2 then add_student
        when 3 then return
      else
        puts " Error: #{input} ist not valid.".red
      end
    end

    private

    # method to create and add a simple person
    def self.add_simple_person
      print "Enter name: "
      name = gets.chomp

      p = Person::Person.new(name)
      Input.data_handler.repository.add_person(p)
      puts "Person with id #{p.id} added successfully.".green
    end

    # method to create and add a student
    def self.add_student
      name = get_entry("Enter name: ")
      mat_nr = get_entry("Enter matriculation number: ").to_i

      s = Person::Student.new(name, mat_nr)
      Input.data_handler.repository.add_person(s)
      puts "Student with id #{s.id} added successfully.".green
    end

    # method the get the input to a given console output
    # @param [String] message the console output
    def self.get_entry(message)
      print message.blue.bright
      gets.chomp
    end

  end

end
