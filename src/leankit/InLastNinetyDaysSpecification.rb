module LeanKit
	class InLastNinetyDaysSpecification
	    def initialize
	      @ninety_days_ago = DateTime.now - 90
	    end

	    def is_satisfied_by(date_time)
	      date_time >= @ninety_days_ago
	    end
  	end
end