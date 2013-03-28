var KeepAlive = function(options){	
	new IntervalTimer({ 
		timePeriod : options.timeInterval,
		onInterval : options.page.reload
	});
};