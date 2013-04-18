var Builds = Builds || {};
(function(module){

	module.PipelinesList = function(list_id){
		function clear(element){
			$(list_id).empty();
		}
		function add(element){
			$(list_id).append(buildingElementTemplate.build(pipeline));
		}

		return {
			add: add,
			clear: clear
		};
	};

	module.BuildStatus = function(options){
		var BUILD_FAILED = 'Failure',
			FAILED_CLASS = "builds-failed",
			BUILD_STATUS_WIDGET = $(".build_status"),
			failedBuildsList = options.failedBuildsList,
			runningBuildsList = options.runningBuildsList,
			failedElementTemplate = options.failedElementTemplate;

		function update(data){
			clearTheLists();

			var pipelines = data.items;

			createTheLists(pipelines);
		};

		function createTheLists(pipelines){

			var pipelineCount = 0;
			
			for(pipelineCount; pipelineCount < pipelines.length; pipelineCount++){
				var pipeline = pipelines[pipelineCount];
					if(pipeline.status === BUILD_FAILED){
						BUILD_STATUS_WIDGET.addClass(FAILED_CLASS);
						var element = "<li><span class='label'>" + pipeline.pipeline_name+ "</span> <span class='value'>" + pipeline.stage_name+ "</span></li>";
						failedBuildsList.add(element);
					}
					else{
						var element = "<li><span>BUILDING -- </span><span class='label'>" + pipeline.pipeline_name+ "</span> <span class='value'>" + pipeline.stage_name+ "</span></li>";
						runningBuildsList.add(element);
					}
			}
		}

		function clearTheLists(){
			failedBuildsList.clear();
			runningBuildsList.clear();
		}


		return {
			update : update
		}
	};



})(Builds);

