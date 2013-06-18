var LineGraphWrapper = function(options){
	var rickshawGraph = new Rickshaw.Graph({
			element: options.element,
			renderer: 'line',
			series: [{color: options.lineColor, data: [{x:0, y:0}] }]
		}),
		rickshawAxis = new Rickshaw.Graph.Axis.Y({
			graph: rickshawGraph,
			tickFormat: Rickshaw.Fixtures.Number.formatKMBT
		});

	function render(maxY,points){
		rickshawGraph.max = maxY;
		rickshawGraph.series[0].data = points
		rickshawGraph.render();
	}

	return{
		render: render
	};
};


var LineGraphFactory = function(element,lineColor){
	
	function create(){
		return new LineGraphWrapper({
			element: element,
			lineColor: lineColor
			});
	}

	return{
		create:create
	};
};
