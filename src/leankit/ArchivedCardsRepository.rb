module LeanKit
	class ArchivedCardsRepository
	    def initialize(board_id)
	      @board_id = board_id
	    end

	    def get
	      archive = get_archive_live_cards + get_archive_waste_cards
	    end

	    private
	    def get_archive_live_cards
	      LeanKitKanban::Archive.fetch(@board_id)[0][0]['ChildLanes'][0]['Lane']['Cards']	      
	    end

	    def get_archive_waste_cards
	      LeanKitKanban::Archive.fetch(@board_id)[0][0]['ChildLanes'][1]['Lane']['Cards']
	    end
  	end
end
