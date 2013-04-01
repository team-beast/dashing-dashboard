module LeanKit
	class CardHistoryRespository
	    def initialize(board_id)
	      @board_id = board_id
	    end

	    def get(card_id)
	      LeanKitKanban::Card.get_card_history(@board_id, card_id)[0]
	    end
  	end
end