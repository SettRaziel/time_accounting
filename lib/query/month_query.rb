# @Author: Benjamin Held
# @Date:   2015-08-24 13:15:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-25 11:58:19

require_relative '../entity/time'

module Query

  # statistic class to calculate to work time for a given month and year
  class MonthQuery < Base

    def self.get_monthly_worktime(id, year, month)
      get_interval_worktime(id, year, month,
                           (Time.days_in_month(year,month) * 24))
    end

    private

    def self.get_tasks_during(year, month, all_task)
      check_date = Time.new(year, month)
      puts check_date.next_month
      all_task.select { |task|
        task.start_time >= check_date &&
        task.end_time <= check_date.next_month
      }
    end

    def self.get_tasks_over(year, month, all_task)
      check_date = Time.new(year, month)
      all_task.select { |task|
        task.start_time < check_date && task.end_time > check_date.next_month
      }
    end

    def self.get_tasks_into(year, month, all_task)
      check_date = Time.new(year, month)
      all_task.select { |task|
        task.start_time < check_date &&
        task.end_time > check_date &&
        task.end_time < check_date.next_month
      }
    end

    def self.get_tasks_beyond(year, month, all_task)
      check_date = Time.new(year, month)
      all_task.select { |task|
        task.start_time > check_date &&
        task.start_time < check_date.next_month &&
        task.end_time > check_date.next_month
      }
    end

    def self.get_hours_during(tasks)
      total = 0
      tasks.each { |task|
        total += task.end_time - task.start_time
      }

      total = (total / 3600).round(2)
    end

    def self.get_hours_into(tasks, year, month)
      total = 0
      month = Time.new(year, month)
      tasks.each { |task|
        total += task.end_time - month
      }

      total = (total / 3600).round(2)
    end

    def self.get_hours_beyond(tasks, year, month)
      total = 0
      next_month = Time.new(year, month).next_month
      tasks.each { |task|
        total += next_month - task.start_time
      }

      total = (total / 3600).round(2)
    end

  end

end
