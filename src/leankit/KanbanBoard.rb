module LeanKit
  class KanbanBoard
    def initialize(board_id, display_cycle_time, within_cycle_range_specification = LeanKit::InLastNinetyDaysSpecification.new)
      @within_cycle_range_specification = within_cycle_range_specification
      @archieved_cards_respository = ArchivedCardsRepository.new(board_id)
      @card_cycle_time_factory = CardCycleTimeFactory.new(board_id)
      @display_cycle_time = display_cycle_time
      LeanKitKanban::Config.email    = "lrteambeast@gmail.com"
      LeanKitKanban::Config.password = "TeamBeast13"
      LeanKitKanban::Config.url = "lrtest.leankit.com"
    end

    def calculate_cycle_time
      overall_cycle_time = OverallCycleTime.new(@display_cycle_time)
      archive = @archieved_cards_respository.get
      archive.each do | archived_card |             
        card_last_moved_date = DateTime.strptime(archived_card['LastMove'], '%d/%m/%Y')
        if @within_cycle_range_specification.is_satisfied_by(card_last_moved_date)          
          card_cycle_time = @card_cycle_time_factory.create(archived_card["Id"])                   
          overall_cycle_time.add_card_cycle_time(card_cycle_time)          
        end
      end
      overall_cycle_time.total
    end
  end  
end