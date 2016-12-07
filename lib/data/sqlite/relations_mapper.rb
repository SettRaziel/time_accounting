# @Author: Benjamin Held
# @Date:   2016-12-07 20:11:38
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-12-07 20:25:36

require_relative 'db_basic'

module DBMapping

  # class to apply ER-mapping for person to tasks relations in a sqlite database
  class RelationsMapper

    # initialization
    # @param [String] filepath the path to the database
    def initialize(filepath)
      @db_base = SqliteDatabase::DBBasic.new(filepath)
    end

    # public method to map available tasks the its corresponding persons
    # @param [Hash] relations the mapping person_id => array of taks_ids
    def generate_person_and_task_relations(relations)
      relations.each_pair { |person_id, values|
        values.each { |task_id|
          @db.map_task_to_person(person_id, task_id)
        }
      }
    end

    private

    # @return [DBBasic] the basic database adapter
    attr_reader :db_base

  end

end
