(function(){
	module("Build Status Order");

	test("Given pipelines are not in alphabetical order, Then builds list adds them in pipeline_name order",function(){
			buildData = { 
				items: [{pipeline_name: "bob", stage_name: "fred", status: "Failure"},{pipeline_name: "Adam", stage_name: "fred", status: "Failure"}]
			};
			pipelineList = new OrderedPipelineFactory().create(buildData);
			equal(pipelineList[0].pipeline_name,"Adam");
	});

	test("Given pipelines names are the Same, Then builds list adds them in pipeline_stage order",function(){
			buildData = { 
				items: [{pipeline_name: "Adam", stage_name: "Ben", status: "Failure"},{pipeline_name: "Adam", stage_name: "Aaron", status: "Failure"}]
			},
			pipelineList = new OrderedPipelineFactory().create(buildData);
			equal(pipelineList[1].stage_name,"Ben");
	});
})();

var MockBuildList = function(){
	var addedPipelines = [];
	function clear(){}
	function add(pipeline){
		addedPipelines.push(pipeline);
	}

	return{
		addedPipelines: addedPipelines,
		clear: clear,
		add : add
	};

};

var stubBuildList = {
	clear : function(){},
	add : function(){}
};

