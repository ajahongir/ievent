class Event < ActiveRecord::Base
  belongs_to :user

  @@notify_type = %w(Once Daily Weekly Monthly Yearly)

  scope :active, where('STRFTIME("%Y-%m-%d", [from]) <= ?', DateTime.now.strftime("%Y-%m-%d"))
  scope :allDay, lambda { |_allDay| where(:allDay => _allDay) }
  scope :repeat, lambda { |_repeat| where("repeat = ?", _repeat) }
  scope :once, lambda { |allDay_|
    if allDay_
      repeat("once").allDay(allDay_).where('STRFTIME("%Y-%m-%d", [from]) = ?', DateTime.now.strftime("%Y-%m-%d"))
    else
      repeat("once").allDay(allDay_).where('STRFTIME("%Y-%m-%d %H:%M", [from]) = ?', DateTime.now.strftime("%Y-%m-%d %H:%M"))
    end
  }

  scope :daily, lambda { |allDay_|
    if allDay_
      active.repeat("daily").allDay(allDay_)
    else
      active.repeat("daily").allDay(allDay_).where('STRFTIME("%H:%M", [from]) = ?', DateTime.now.strftime("%H:%M"))
    end
  }

  scope :weekly, lambda { |allDay_|
    if allDay_
      active.repeat("weekly").allDay(allDay_).where('STRFTIME("%w", [from]) = ?', DateTime.now.strftime("%w"))
    else
      active.repeat("weekly").allDay(allDay_).where('STRFTIME("%w %H:%M", [from]) = ?', DateTime.now.strftime("%w %H:%M"))
    end
  }

  scope :monthly, lambda { |allDay_|
    if allDay_
      active.repeat("monthly").allDay(allDay_).where('STRFTIME("%d", [from]) = ?', DateTime.now.strftime("%d"))
    else
      active.repeat("monthly").allDay(allDay_).where('STRFTIME("%d %H:%M", [from]) = ?', DateTime.now.strftime("%d %H:%M"))
    end
  }

  scope :yearly, lambda { |allDay_|
    if allDay_
      active.repeat("yearly").allDay(allDay_).where('STRFTIME("%m:%d", [from]) = ?', DateTime.now.strftime("%m:%d"))
    else
      active.repeat("yearly").allDay(allDay_).where('STRFTIME("%m:%d %H:%M", [from]) = ?', DateTime.now.strftime("%m:%d %H:%M"))
    end
  }

  def notify
    EventMailer.event_email(self)
  end

  class << self

    def notify_types
      @@notify_type
    end

    def notify
      [once_, daily_, weekly_, monthly_, yearly_].flatten.compact.each { |event|
        event.notify
      }
    end

    def once_
      events = once(false)
      events = once(true) + events if DateTime.now.strftime("%H:%M").eql?("02:12")
      events
    end

    def daily_
      events = daily(false)
      events = daily(true) + events if DateTime.now.strftime("%H:%M").eql?("09:00")
      events
    end

    def weekly_
      events = weekly(false)
      events = weekly(true) + events if DateTime.now.strftime("%H:%M").eql?("09:00")
      events
    end

    def monthly_
      events = monthly(false)
      events = monthly(true) + events if DateTime.now.strftime("%H:%M").eql?("09:00")
      events
    end

    def yearly_
      events = yearly(false)
      events = yearly(true) + events if DateTime.now.strftime("%H:%M").eql?("09:00")
      events
    end

  end

end

