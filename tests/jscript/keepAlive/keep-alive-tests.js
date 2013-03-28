(function(){
	module("Keep Alive");
	test("When created, Then interval timer is set for keep alive time interval", function(){
		var intervalTimePeriod,
			keepAliveTimeInterval = 1500;
		IntervalTimer = function(options){
			intervalTimePeriod = options.timePeriod
		};
		new KeepAlive({
			timeInterval : keepAliveTimeInterval,
			page : { reload : function(){} }
		});
		equal(intervalTimePeriod, keepAliveTimeInterval); 
	});

	test("When created And interval hit, Then window reloaded", function(){
		var windowReloaded = false,
			fakeIntervalTimer = function(options){
				options.onInterval();
			},
			mockPage = {
				reload : function(){
					windowReloaded = true;
				}
			};		
		
		IntervalTimer = fakeIntervalTimer;
		new KeepAlive({ page : mockPage});
		equal(windowReloaded, true);
	});


})();

var Page = function(){
	function reload(){
		window.location.reload(true);
	}

	return 	{
		reload : reload
	}
};