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
		new CycleTime.CycleTimeGraph(fakeLineGraphFactory).update(pointsToBeRendered);
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
		new CycleTime.CycleTimeGraph(fakeLineGraphFactory).update( pointsToBeRendered);
		equal(rickshawWrapperRenderedMaxY,expectedMaxY);
	});

})();

var CycleTime = CycleTime || {};
(function(module){
	module.CycleTimeGraph = function(lineGraphFactory){
			var lineGraph = lineGraphFactory.create(),
				maximumYCalculator = new DoubleYCalulator();

			function update(points){
				var maxY = maximumYCalculator.calculate(points,this);
			}

			function renderGraph(maxY,points){
				lineGraph.render(maxY,points);
			}

			return{
				update: update,
				renderGraph: renderGraph
			};
	};

	var DoubleYCalulator = function(){
		largestHeightCalculator = new LargestHeightCalculator()

		function calculateMaximumHeightForAll(points){
			return points.map(function(point){
				return point.y * 2;
			});
		}

		function calculate(points,cycleTimeGraph){
			heights = calculateMaximumHeightForAll(points);
			maxY = largestHeightCalculator.calculate(heights);
			cycleTimeGraph.renderGraph(maxY,points);
		}

		return {
			calculate: calculate
		};
	};

	var LargestHeightCalculator = function(){
		function calculate(heights){
			return Math.max.apply(null, heights);
		}
		return{
			calculate: calculate
		};
	};

})(CycleTime);

