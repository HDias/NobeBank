module Bank
  class TaxValueTransfer
    def get(value:, time: Time.now)
      tax = busines_hours?(time) ? 5 : 7

      tax += 10 if value > 1000

      tax
    end

    def busines_hours?(time)
      time >= start_time && time <= end_time &&
        time.strftime('%H%M%S') >= '090000' &&
        time.strftime('%H%M%S') <= '180000'
    end

    def start_time
      Time.zone.now.beginning_of_week.change({ hour: 9, min: 0, sec: 0 })
    end

    def end_time
      Time.zone.now.end_of_week.change({ hour: 18, min: 0, sec: 0 }) - 2.day
    end
  end
end
