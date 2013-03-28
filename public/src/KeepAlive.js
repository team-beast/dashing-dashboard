var KeepAlive = function(options){	
	new IntervalTimer({ 
		timePeriod : options.timeInterval,
		onInterval : keepDashboardAwake
	});	

	function keepDashboardAwake(){
		options.page.reload();
		options.serviceLayer.wakeUp();
	}
	
};