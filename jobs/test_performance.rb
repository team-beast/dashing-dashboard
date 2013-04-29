@points = []

SCHEDULER.every '1m', :first_in => 0 do		
	random_number = rand(0..30)
	point = {:x => @points.length, :y => random_number}
	@points.push(point)	
	send_event('performance', points: @points )
end