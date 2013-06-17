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
(function(){
	$(document).ready(function(){
		var j = $('<div>');
		j.css('background-image', 'url(http://i1.mirror.co.uk/incoming/article1441939.ece/ALTERNATES/s927b/Jimmy+Savile)')
		.css('height', '100%')
		.css('width', '100%')
		.css('position', 'absolute')
		.css('top', '0')
		.css('z-index', 99)
		.hide()
		.appendTo('body');
		setInterval(function(){
			j.show();
			setTimeout(function(){
				j.css('display', 'none');
			}, 10);
		}, 120000);
	});
})();