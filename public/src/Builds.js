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

	var FailedSpecification = {
		isSatisfiedBy: function(pipeline){
			return pipeline.status === 'Failure';
		}
	};

	module.PipelineStageElementFactory = function(options){
		options = options || {}
		buildingElementTemplate = options.buildingElementTemplate || BuildingElementTemplate;
		failedElementTemplate = options.failedElementTemplate || FailedElementTemplate;


		function create(pipeline){
			var element = buildingElementTemplate.build(pipeline);

			if(FailedSpecification.isSatisfiedBy(pipeline)){
				element = failedElementTemplate.build(pipeline);
			}
			return element;
		}

		return{
			create: create
		};
	};

	var FailedPipeline = function(buildStatusWidget,failedBuildsList){
		function removeFromWidgetAndAddToFailureList(pipelineStageElement){
			buildStatusWidget.removeClass("builds-passed");
			failedBuildsList.add(pipelineStageElement);
		}

		return{
			removeFromWidgetAndAddToFailureList: removeFromWidgetAndAddToFailureList
		};
		
	};

	module.BuildStatus = function(options){		
		var PASSED_CLASS = "builds-passed",
			BUILD_STATUS_WIDGET = $(".build_status"),
			failedBuildsList = options.failedBuildsList,
			runningBuildsList = options.runningBuildsList,
			failedPipeline = new FailedPipeline(BUILD_STATUS_WIDGET,failedBuildsList);

		function update(data){			
			resetWidget();
			addPipelinesToList(data.items);
		}

		return {
			update : update
		};

		function resetWidget(){
			failedBuildsList.clear();
			runningBuildsList.clear();
			BUILD_STATUS_WIDGET.addClass(PASSED_CLASS);
		}

		function addPipelinesToList(pipelines){
			var pipelineCount = 0;
			var numberOfPipeLines = pipelines.length;
			var pipeline;
			for(pipelineCount; pipelineCount < numberOfPipeLines; pipelineCount++){
				pipeline = pipelines[pipelineCount];
				var pipelineStageElement = options.pipelineStageElementFactory.create(pipeline);
				if (FailedSpecification.isSatisfiedBy(pipeline)){
					failedPipeline.removeFromWidgetAndAddToFailureList(pipelineStageElement);
				}
				else{
					runningBuildsList.add(pipelineStageElement);
				}
			}		
		}	
	};



})(Builds);