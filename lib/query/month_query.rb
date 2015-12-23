# @Author: Benjamin Held
# @Date:   2015-08-24 13:15:27
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-12-23 22:33:28

require_relative '../entity/time'

module Query

  # statistic class to calculate to work time for a given month and year
  class MonthQuery < Base

    def self.get_monthly_worktime(id, year, month)
      tasks = get_data(id, year, month)

      if (tasks[:over].size > 0)
      puts "Worktime: #{Time.days_in_month(year,month) * 24}"
      else
        puts "tasks.during: #{get_hours_during(tasks[:during])} h"
        puts "tasks.into: #{get_hours_into(tasks[:into], year, month)} h"
        puts "tasks.beyond: #{get_hours_beyond(tasks[:beyond], year, month)} h"
      end

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
