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
				graphPoints = [],
				maximumSelector = new MaximumSelector(render),
				maximumYCalculator = new DoubleYCalulator(maximumSelector);

			function update(points){
				graphPoints = points;
				maximumYCalculator.calculate(points);
			}

			function render(maxY){
				lineGraph.render(maxY,graphPoints);
			}

			return{
				update: update
			};
	};

	var DoubleYCalulator = function(maximumSelector){
		
		function calculate(points){
			heights = points.map(function(point){
				return point.y * 2;
			});
			maximumSelector.select(heights);
		}

		return {
			calculate: calculate
		};
	};

	var MaximumSelector = function(render){
		
		function select(values){
			maxY = Math.max.apply(null, values);
			render(maxY)
		}

		return{
			select: select
		};
	};

})(CycleTime);

