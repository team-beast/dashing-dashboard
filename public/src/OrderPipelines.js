var OrderedPipelineFactory = function(){

	function create(data){
		pipelines = data.items;
		pipelines.sort(orderByPipelineName);
		return pipelines;
	}

	function orderByPipelineName(first,second){
		if(first.pipeline_name < second.pipeline_name) return -1;
		if(first.pipeline_name === second.pipeline_name) return orderByStageName(first,second);
		if(first.pipeline_name > second.pipeline_name) return 1;
	}
		
	function orderByStageName(first,second){
		if(first.stage_name < second.stage_name) return -1;
		if(first.stage_name > second.stage_name) return 1;
	}

	return{
		create: create
	};
};

function orderPipelines(pipelines){
	pipelines.sort(function(first,second){
		if(first.pipeline_name < second.pipeline_name) return -1;
		if(first.pipeline_name === second.pipeline_name) return blah(first,second);
		if(first.pipeline_name > second.pipeline_name) return 1;
	});

	return pipelines;
}

function blah(first,second){
	if(first.stage_name < second.stage_name) return -1;
	if(first.stage_name > second.stage_name) return 1;
}