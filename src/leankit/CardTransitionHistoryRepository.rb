module LeanKit
	class CardTransitionHistoryRespository
	    CARD_TRANSISITION_KEY_NAME = "FromLaneId" 

	    def initialize(card_history_respository)
	      @card_history_respository = card_history_respository
	    end

	    def get(card_id)
	      card_history = @card_history_respository.get(card_id)
	      card_transistion_history = card_history.select { |card_history_item| card_history_item.key? CARD_TRANSISITION_KEY_NAME }
	    end
	end
end