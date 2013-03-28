var KeepAlive = function(options){	
	new IntervalTimer({ 
		timePeriod : options.timeInterval,
		onInterval : keepDashboardAwake
	});	

	function keepDashboardAwake(){
		options.serviceLayer.wakeUp();
		options.page.reload();		
	}
	
};