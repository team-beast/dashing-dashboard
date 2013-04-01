module LeanKit
	class OverallCycleTime
	    def initialize(display_cycle_time)
	      @card_count = 0 
	      @card_total_cycle_time = 0
	      @display_cycle_time = display_cycle_time
	    end

	    def add_card_cycle_time(card_cycle_time)
	      @card_count += 1
	      @card_total_cycle_time += card_cycle_time.time_period
	    end

	    def total
	      cycle_time_total = (@card_count != 0 ) ? @card_total_cycle_time / @card_count : 0
	      @display_cycle_time.show_cycle_time(cycle_time_total)
	    end
	end
end