# @Author: Benjamin Held
# @Date:   2016-11-25 19:47:28
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-06 19:51:11

require_relative '../../entity/person/person'
require_relative 'db_basic'

module DBMapping

  # Class to apply ER-mapping for {Person::Person} objects to a sqlite database
  class PersonMapper

    # initialization
    # @param [String] filepath the path to the database
    def initialize(filepath)
      @db_base = SqliteDatabase::DBBasic.new(filepath)
    end

    # public method to transform database persons to entity {Person::Person}
    # @return [Array] all transformed {Person::Person} entities
    def generate_persons
      results = @db_base.query_persons
      persons = Array.new()
      results.each { |result|
        persons << Person::Person.new(result['Name'], Integer(result['Id']))
      }
      return persons
    end

    # method to persist a list of {Person::Person}s to the database
    # @param [Array] persons the {Person::Person} that should be be persisted
    def persist_persons(persons)
      persons.each { |person|
        @db_base.insert_person(person.id, person.name)
      }
      nil
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

  end

end
