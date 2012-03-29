class Event < ActiveRecord::Base
	belongs_to :user

	@@notify_type = ["Once", "Daily", "Weekly", "Monthly", "Yearly"]

	def self.notify_types
		@@notify_type
	end

end

