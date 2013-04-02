module LeanKit
	class CardTransitionHistoryRespository
	    CARD_TRANSISITION_KEY_NAME_1 = "FromLaneId" 
	    CARD_TRANSISITION_KEY_NAME_2 = "ToLaneId" 

	    def initialize(card_history_respository)
	      @card_history_respository = card_history_respository
	    end

	    def get(card_id)
	      card_history = @card_history_respository.get(card_id)
	      card_transistion_history = card_history.select do |card_history_item| 
	      	(card_history_item.key? CARD_TRANSISITION_KEY_NAME_1) || (card_history_item.key? CARD_TRANSISITION_KEY_NAME_2)
	      end
	    end
	end
end