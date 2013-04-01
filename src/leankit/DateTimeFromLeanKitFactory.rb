module LeanKit
	class DateTimeFromLeanKitFactory
	    LEANKIT_DATETIME_FORMAT = "%d/%m/%Y at %l:%M:%S %p"

	    def create(leankit_date_time)
	      DateTime.strptime(leankit_date_time, LEANKIT_DATETIME_FORMAT)
	    end
	end
end