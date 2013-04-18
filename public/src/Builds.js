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
			$(list_id).append(element);
		}

		return {
			add: add,
			clear: clear
		};
	};

	module.BuildStatus = function(options){
		var BUILD_FAILED = 'Failure',
			PASSED_CLASS = "builds-passed",
			FAILED_BUILDS_LIST_ID = "#failed_builds",
			RUNNING_BUILDS_LIST_ID = "#running_builds",
			BUILD_STATUS_WIDGET = $(".build_status"),
			failedBuildsList = options.failedBuildsList,
			runningBuildsList = options.runningBuildsList,
			buildingElementTemplate = options.buildingElementTemplate || BuildingElementTemplate,
			failedElementTemplate = options.failedElementTemplate || FailedElementTemplate;

		function update(data){
			failedBuildsList.clear();
			runningBuildsList.clear();
			BUILD_STATUS_WIDGET.addClass(PASSED_CLASS);
			addPipelinesToList(data.items);
		};

		function addPipelinesToList(pipelines){
			var pipelineCount = 0;
			for(pipelineCount; pipelineCount < pipelines.length; pipelineCount++){
				var pipeline = pipelines[pipelineCount];
				create(pipeline);
			}		
		}

		function create(pipeline){
			if(pipeline.status == BUILD_FAILED){
				var element = failedElementTemplate.build(pipeline);
				BUILD_STATUS_WIDGET.removeClass(PASSED_CLASS);
				failedBuildsList.add(element);
			}
			else{
				var element = buildingElementTemplate.build(pipeline);
				runningBuildsList.add(element);
			}
		}

		return {
			update : update
		}
	};



})(Builds);

