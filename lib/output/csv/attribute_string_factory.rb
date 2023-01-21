require_relative '../../entity/person/person'

# singleton class to create a formatted {String} with the attribute names of
# of the submitted class
class AttributeStringFactory

  # method to return the formatted {String} for the class of the given object
  # @param [Person] person a person or a child class of person
  # @return [String] the formatted string with the attributes
  # @raise [TypeError] if no case of the given class of the object is found
  def self.get_attributes_to_person(person)
    case person
      when Person::Student then return "Name:;Id:;Mat.-Nr.:"
      when Person::Person then return "Name:;Id:"
    else
      raise TypeError, "Invalid class type for factory: #{person.class}"
    end
  end

  # method to return the formatted {String} for the task attributes
  # @return [String] the formatted string with the attributes of the task
  def self.get_attributes_to_task
    "Task-Id;Description;Start;End"
  end

end
