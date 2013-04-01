module LeanKit
	class CardCycleTimeFactory
	    def initialize(board_id)
	      @cycle_time_calculator = CycleTimeCalculator.new
	      @card_cycle_history_factory = CardCycleHistoryFactory.new(
	        CardTransitionHistoryRespository.new(
	          CardHistoryRespository.new(board_id)))
	    end

	    def create(card_id)
	      card_cycle_history = @card_cycle_history_factory.create(card_id)
	      cycle_time = @cycle_time_calculator.calculate(
	        card_cycle_history.start_cycle_date_time, 
	        card_cycle_history.end_cycle_date_time)
	      LeanKit::CardCycleTime.new(time_period: cycle_time, end_date: card_cycle_history.end_cycle_date_time)
	    end
	  end 

	class CardCycleTime
	    attr_reader :time_period, :end_date

	    def initialize(values)
	      @time_period = values[:time_period]
	      @end_date = values[:end_date]
	    end
	end
 end