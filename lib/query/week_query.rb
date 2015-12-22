# @Author: Benjamin Held
# @Date:   2015-08-26 15:03:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2015-08-26 16:32:52

module Query

  class WeekQuery

    def self.get_data(id, year, calendar_week)
      start_time = get_monday_of_calendar_week(year, calendar_week)
      puts start_time
      end_time = get_next_monday(start_time)
      start_time = Time.new(start_time.year, start_time.month, start_time.day)
      puts "#{start_time} , #{end_time}"

      all_task = Query.data.get_tasks_to_person(id)
      tasks = {
        :during => get_tasks_during(year, calendar_week, all_task),
        :over => get_tasks_over(year, calendar_week, all_task),
        :into => get_tasks_into(year, calendar_week, all_task),
        :beyond => get_tasks_beyond(year, calendar_week, all_task)
      }

      puts "tasks.during: #{tasks[:during].inspect}"
      puts "tasks.over: #{tasks[:over].inspect}"
      puts "tasks.into: #{tasks[:into].inspect}"
      puts "tasks.beyond: #{tasks[:beyond].inspect}"

      return tasks
    end

    def self.get_weekly_worktime(id, year, calendar_week)
      tasks = get_data(id, year, calendar_week)

      if (tasks[:over].size > 0)
      puts "Worktime: #{7 * 24}"
      else
        puts "tasks.during: #{get_hours_during(tasks[:during])} h"
        puts "tasks.into: #{get_hours_into(tasks[:into], year, calendar_week)} h"
        puts "tasks.beyond: #{get_hours_beyond(tasks[:beyond], year, calendar_week)} h"
      end
    end

    private

    def self.get_monday_of_calendar_week(year, calendar_week)
      start = Time.new(year)

      # Monday of calendar week 1
      start = get_next_monday(start)
      start += (calendar_week - 2) * 7 * 60 * 60 * 24
    end

    def self.get_next_monday(time)
      time + (7 - time.get_int_wday) * 60 * 60 * 24
    end

    def self.calculate_start_and_end_day(year, calendar_week)
      start_time = get_monday_of_calendar_week(year, calendar_week)
      end_time = get_next_monday(start_time)
      [Time.new(start_time.year, start_time.month, start_time.day), end_time]
    end

    def self.get_tasks_during(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      all_task.select { |task|
        task.start_time >= days[0] &&
        task.end_time <= days[1]
      }
    end

    def self.get_tasks_over(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      all_task.select { |task|
        task.start_time < days[0] && task.end_time > days[1]
      }
    end

    def self.get_tasks_into(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      all_task.select { |task|
        task.start_time < days[0] &&
        task.end_time > days[0] &&
        task.end_time < days[1]
      }
    end

    def self.get_tasks_beyond(year, calendar_week, all_task)
      days = calculate_start_and_end_day(year, calendar_week)
      all_task.select { |task|
        task.start_time > days[0] &&
        task.start_time < days[1] &&
        task.end_time > days[1]
      }
    end

    def self.get_hours_during(tasks)
      total = 0
      tasks.each { |task|
        total += task.end_time - task.start_time
      }

      total = (total / 3600).round(2)
    end

    def self.get_hours_into(tasks, year, calendar_week)
      total = 0
      start_time = calculate_start_and_end_day(year, calendar_week)[0]
      tasks.each { |task|
        total += task.end_time - start_time
      }

      total = (total / 3600).round(2)
    end

    def self.get_hours_beyond(tasks, year, calendar_week)
      total = 0
      next_calendar_week = calculate_start_and_end_day(year, calendar_week)[1]
      tasks.each { |task|
        total += next_calendar_week - task.start_time
      }

      total = (total / 3600).round(2)
    end

  end

end
