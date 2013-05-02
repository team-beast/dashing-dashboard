(function(){
	module("Cycle Time Graph Tests")
	test("Nothing Breaks ", function(){
		var lineGraphFactory = new LineGraphFactory(document.querySelector("#chart"),'#FF00FF'),
			cycleTimeGraph = new CycleTime.CycleTimeGraph(lineGraphFactory);

		cycleTimeGraph.update([{x:1,y:10}])
		equal(true, true);
	});

})();


