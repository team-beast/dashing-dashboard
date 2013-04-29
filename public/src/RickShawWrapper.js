var LineGraphWrapper = function(options){
	var rickshawGraph = new RickShaw.Graph({
			element: options.element,
			renderer: 'line',
			series: [{color: options.lineColor, data: [{x:0, y:0}] }]
		}),
		rickshawAxis = new Rickshaw.Graph.Axis.Y({
			graph: rickshawGraph,
			tickFormat: options.tickformat
		});

		})

	function render(maxY){
		rickshawGraph.max = maxY;
		rickshawGraph.series[0].data = points
		rickshawGraph.render();
	}

	return{
		render: render
	};
}