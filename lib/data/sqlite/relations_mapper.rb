# This module holds the classes to realize an ER-Mapping from the application
# entities to the corresponding Sqlite3 tables.
module DBMapping

  # class to apply ER-mapping for person to tasks relations in a sqlite database
  class RelationsMapper < Base

    # initialization
    # @param [SQLite3::Database] database a reference of the database
    def initialize(database)
      super(database)
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

    # method to retrieve the task ids assigned to a person represented by its id
    # @param [Integer] p_id the person id
    # @return [Array] the task ids
    def retrieve_tasks_for_person(p_id)
      assignments = @db_base.query_assignments_for_person(p_id)
      results = Array.new()
      assignments.each { |result|
        results << result['T_Id']
      }
      return results
    end

  end

end
