module LeanKit
	class CycleTimeCalculator
	    def calculate(start_date, end_date)
	      (end_date - start_date).to_f
	    end
	end
end