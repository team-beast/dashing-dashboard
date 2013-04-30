(function(){
	module("Cycle Time Graph Tests")
	test("When new cycle time graph, Then lineGraphFactory create called ", function(){
		var createCalled = false;
		mockLineGraphFactory = {
			create: function(){
				createCalled = true;
			}
		};
		new CycleTime.CycleTimeGraph(mockLineGraphFactory);
		equal(true, createCalled);
	});

	test("When cycle time graph is rendered with points, Then lineGraphWrapper receives correct points", function(){
		var rickshawWrapperRenderedPoints = null,
			pointsToBeRendered = [{x:0,y:0}],
			mockLineGraphWrapper = {
				render: function(maxY,points){
					rickshawWrapperRenderedPoints = points;
				}
			},
			fakeLineGraphFactory = {
				create: function(){
					return mockLineGraphWrapper;
				}
			};
		new CycleTime.CycleTimeGraph(fakeLineGraphFactory).render(pointsToBeRendered);
		equal(pointsToBeRendered, rickshawWrapperRenderedPoints)
	});

	test("When cycle time graph is rendered with multiple points, Then correct lineGraphWrapper receives correct maxY", function(){
		var rickshawWrapperRenderedMaxY = null,
			expectedMaxY = 100,
			pointsToBeRendered = [{x:0, y: 0}, {x:0, y: 50},{x:0, y: 5}, {x:0, y: 7},{x:0, y: 15}, {x:0, y: 20}],
			mockLineGraphWrapper = {
				render: function(maxY, points){
					rickshawWrapperRenderedMaxY = maxY; 
				}
			},
			fakeLineGraphFactory = {
				create: function(){
					return mockLineGraphWrapper;
				}
			};
		new CycleTime.CycleTimeGraph(fakeLineGraphFactory).render( pointsToBeRendered);
		equal(rickshawWrapperRenderedMaxY,expectedMaxY);
	});

})();

var CycleTime = CycleTime || {};
(function(module){
	module.CycleTimeGraph = function(lineGraphFactory){
			var lineGraph = lineGraphFactory.create(),
				maximumYCalculator = new MaximumYCalculator();

			function render(points){
				var maxY = maximumYCalculator.calculate(points);
				lineGraph.render(maxY,points);
			}

			return{
				render: render
			};
	};

	var MaximumYCalculator = function(){
		
		function calculate(points){		
			var heights = calculateMaximumHeightForAll(points);
			maxY = calculateLargestHeight(heights);
			return maxY;
		} 

		function calculateLargestHeight(heights){
			return Math.max.apply(null, heights);
		}
		function calculateMaximumHeightForAll(points){
			return points.map(function(point){
				return point.y * 2;
			});
		}
		return{
			calculate: calculate
		};
	};
})(CycleTime);

