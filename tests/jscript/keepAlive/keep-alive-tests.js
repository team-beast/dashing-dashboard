(function(){
	module("Keep Alive");
	var fakeServiceLayer = {
			wakeUp : function(){}
		},
		fakeIntervalTimer = function(options){
			options.onInterval();
		};

	test("When created, Then interval timer is set for keep alive time interval", function(){
		var intervalTimePeriod,
			keepAliveTimeInterval = 1500;
		IntervalTimer = function(options){
			intervalTimePeriod = options.timePeriod
		};
		new KeepAlive({
			timeInterval : keepAliveTimeInterval,
			page : { reload : function(){} },
			serviceLayer : fakeServiceLayer
		});
		equal(intervalTimePeriod, keepAliveTimeInterval); 
	});

	test("When created And interval hit, Then window reloaded", function(){
		var windowReloaded = false,
			mockPage = {
				reload : function(){
					windowReloaded = true;
				}
			};		
		
		IntervalTimer = fakeIntervalTimer;
		new KeepAlive({ 
			page : mockPage,
			serviceLayer : fakeServiceLayer
		});
		equal(windowReloaded, true);
	});

	test("When created and interval hit, Then team beast services kept awake", function(){
		var servicesAwoken = false,
			mockServiceLayer = {
				wakeUp : function(){
					servicesAwoken = true;
				}
			};
		IntervalTimer = fakeIntervalTimer;
		new KeepAlive({
			page : { reload : function(){} },
			serviceLayer : mockServiceLayer
		});
		equal(servicesAwoken, true);
	});

	test("When created and interval not hit, Then team beast services not kept awake", function(){
		var servicesAwoken = false,
			mockServiceLayer = {
				wakeUp : function(){
					servicesAwoken = true;
				}
			};

		IntervalTimer = function(){};
		new KeepAlive({
			page : { reload : function(){} },
			serviceLayer : mockServiceLayer
		});
		equal(servicesAwoken, false);
	});
})();