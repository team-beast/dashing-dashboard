var Builds = Builds || {};
(function(module){

	var BuildingElementTemplate = {
		build : function(pipeline){
			return "<li><span>BUILDING -- </span><span class='label'>" + pipeline.pipeline_name+ "</span> <span class='value'>" + pipeline.stage_name+ "</span></li>"
		}
	}

	var FailedElementTemplate = {
		build : function(pipeline){
			return "<li><span class='label'>" + pipeline.pipeline_name+ "</span> <span class='value'>" + pipeline.stage_name+ "</span></li>"
		}
	}

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
			buildingElementTemplate = options.buildingElementTemplate || BuildingElementTemplate,
			failedElementTemplate = options.failedElementTemplate || FailedElementTemplate;

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

						var element = failedElementTemplate.build(pipeline);
						failedBuildsList.add(element);
					}
					else{
						var element = buildingElementTemplate.build(pipeline);
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

