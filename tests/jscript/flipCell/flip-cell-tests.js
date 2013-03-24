(function(){
	test("Interval Timer created for flip interval time", function(){
		var flipInterval = 2000,
			timerInterval;
		IntervalTimer = function(options){	
			timerInterval = options.timePeriod;
		};
		$('.flips').flipCell({ interval: flipInterval});
		equal(timerInterval, flipInterval);
	});

	test("When timer triggered, then Flip widget called on specified <div>", function(){
		var flipPluginCalled = false;
		IntervalTimer = function(options){
			options.onInterval();
		};
		$.fn.flip = function(){
			flipPluginCalled = true;
		};
		$('.flips').flipCell({});
		equal(flipPluginCalled, true);
	});

	test("When timer triggered, then Flip widget called with matching direction code", function(){
		var flipDirection,
			direction = 'lr';
		IntervalTimer = function(options){
			options.onInterval();
		};
		$.fn.flip = function(options){
			flipDirection = options.direction;
		};
		$('.flips').flipCell({direction: direction});
		equal(flipDirection, direction);
	});

	test("When timer triggers and onAnimation is triggered by flip widget, then initially shown <div> is now hidden", function(){
		IntervalTimer = function(options){
			options.onInterval();
		};
		$.fn.flip = function(options){
			options.onAnimation();
		};
		$('.flips').flipCell({});
		equal($('#initiallyShown').hasClass('hidden'), true);
	});

	test("When timer triggers and onAnimation is triggered by flip widget, then initially hidden <div> is now shown", function(){
		IntervalTimer = function(options){
			options.onInterval();
		};
		$.fn.flip = function(options){
			options.onAnimation();
		};
		$('.flips').flipCell({});
		equal($('#initiallyHidden').hasClass('hidden'), false);
	});
})();