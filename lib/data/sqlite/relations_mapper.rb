# @Author: Benjamin Held
# @Date:   2016-12-07 20:11:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2017-01-10 19:54:33

require_relative 'db_basic'

module DBMapping

  # class to apply ER-mapping for person to tasks relations in a sqlite database
  class RelationsMapper

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      @db_base = SqliteDatabase::DBBasic.new(database)
    end

    # public method to map available tasks the its corresponding persons
    # @param [Hash] relations the mapping person_id => array of task_ids
    def generate_person_and_task_relations(relations)
      relations.each_pair { |person_id, values|
        values.each { |task_id|
          @db_base.map_task_to_person(person_id, task_id)
        }
      }
    end

    # method to retrieve the task assignments to the persons identified by
    # its corresponding ids
    # @return [Hash] the mapping person_id => array of task_ids
    def map_entity_relations
      assignments = @db_base.query_assignments
      results = Hash.new()
      assignments.each { |result|
        results[result['P_Id']] = result['T_Id']
      }
      return results
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

  end

end
