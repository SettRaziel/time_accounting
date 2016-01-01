# @Author: Benjamin Held
# @Date:   2015-08-26 15:03:12
# @Last Modified by:   Benjamin Held
# @Last Modified time: 2016-01-01 09:57:21

module Query

  # statistic class to calculate to work time for a given week of the year
  class WeekQuery < Base

    def self.get_weekly_worktime(id, year, calendar_week)
      get_interval_worktime(id, year, calendar_week, (7*24))
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

    def self.get_hours_into(tasks, year, calendar_week)
      start_time = calculate_start_and_end_day(year, calendar_week)[0]
      get_into_value(tasks, start_time)
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
