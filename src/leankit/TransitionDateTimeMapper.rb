module LeanKit
	class TransitionDateTimeMapper
	    DATE_TIME_KEY = 'DateTime'
	    DESTINATION_LANE_KEY = 'ToLaneTitle'
	    START_CYCLE_LANE = 'Development: In Progress'
	    END_CYCLE_LANE = 'Release: Live'

	    def initialize(date_time_adapter)
	      @date_time_adapter = date_time_adapter
	    end

	    def map_start_from(card_transistion_history)
	      transition = get_transition_to(START_CYCLE_LANE, card_transistion_history)
	      transition = card_transistion_history[0] if transition.nil?
	      transition_date_time = @date_time_adapter.create(transition[DATE_TIME_KEY])
	    end

	    def map_end_from(card_transistion_history)
	      transition = get_transition_to(END_CYCLE_LANE, card_transistion_history)
	      transition = card_transistion_history[card_transistion_history.length-1] if transition.nil?
	      transition_date_time = @date_time_adapter.create(transition[DATE_TIME_KEY])
	    end

	    private
	    def get_transition_to(to_lane_title, card_transistion_history)
	      card_transistion_history.select {|card_transistion_history_item | card_transistion_history_item[DESTINATION_LANE_KEY] == to_lane_title}[0]
	    end
	end
end