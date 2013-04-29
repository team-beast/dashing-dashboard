(function(){
	module("Cycle Time Graph Tests")

	test("When created Then line graph factory receives correct element",function(){
		var passedElement = "fred",
			receivedElement = "",
			mockLineGraphFactory = {
				create: function(options){
					receivedElement = options.element;
				}
			};
		new CycleTimeGraph(mockLineGraphFactory);
		equal(receivedElement,passedElement);
	});

})();

var CycleTimeGraph = function(lineGraphFactory){
		lineGraphFactory.create({element: "fred"})
};
