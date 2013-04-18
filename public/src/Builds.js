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

	module.PipelineStageElementFactory = function(options){
		BUILD_FAILED = 'Failure';
		options = options || {}
		buildingElementTemplate = options.buildingElementTemplate || BuildingElementTemplate;
		failedElementTemplate = options.failedElementTemplate || FailedElementTemplate;

		function create(pipeline){
			var element = buildingElementTemplate.build(pipeline);

			if(pipeline.status == BUILD_FAILED){
				element = failedElementTemplate.build(pipeline);
			}
			return element;
		}

		return{
			create: create
		};
	}

	module.BuildStatus = function(options){
		var BUILD_FAILED = 'Failure',
			PASSED_CLASS = "builds-passed",
			FAILED_BUILDS_LIST_ID = "#failed_builds",
			RUNNING_BUILDS_LIST_ID = "#running_builds",
			BUILD_STATUS_WIDGET = $(".build_status"),
			options = options || {failedBuildsList: new Builds.PipelinesList(FAILED_BUILDS_LIST_ID),
								  runningBuildsList: new Builds.PipelinesList(RUNNING_BUILDS_LIST_ID),
								  pipelineStageElementFactory: new Builds.PipelineStageElementFactory()}
			failedBuildsList = options.failedBuildsList;
			runningBuildsList = options.runningBuildsList;
			pipelineStageElementFactory = options.pipelineStageElementFactory;

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
				var pipelineStageElement = pipelineStageElementFactory.create(pipeline);

				if (pipeline.status === BUILD_FAILED){
					BUILD_STATUS_WIDGET.removeClass(PASSED_CLASS);
					failedBuildsList.add(pipelineStageElement);
				}
				else{
					runningBuildsList.add(pipelineStageElement);
				}
			}		
		}

		return {
			update : update
		}
	};



})(Builds);

