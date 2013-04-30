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
				console.log(lineGraph)
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