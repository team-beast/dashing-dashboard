module LeanKit
	class CardCycleHistoryFactory
	    START_CYCLE_LANE = 'Development: In Progress'
	    END_CYCLE_LANE = 'Release: Live'

	    def initialize(card_transistion_history_repository)
	      @card_transistion_history_repository = card_transistion_history_repository
	      @datetime_from_leankit_datetime_factory = DateTimeFromLeanKitFactory.new
	      @transition_date_time_mapper = TransitionDateTimeMapper.new(DateTimeFromLeanKitFactory.new())
	    end

	    def create(card_id)
	      card_transistion_history = @card_transistion_history_repository.get(card_id)
	      start_cycle_date_time = @transition_date_time_mapper.map_start_from(card_transistion_history)
	      end_cycle_date_time = @transition_date_time_mapper.map_end_from(card_transistion_history)
	      CardCycleHistory.new(start_cycle_date_time: start_cycle_date_time, end_cycle_date_time:  end_cycle_date_time)
	    end
	end

	class CardCycleHistory
	    attr_reader :start_cycle_date_time, :end_cycle_date_time

	    def initialize(values)
	      @start_cycle_date_time = values[:start_cycle_date_time]
	      @end_cycle_date_time = values[:end_cycle_date_time]
	    end
	end
end