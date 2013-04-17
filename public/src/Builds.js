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

	module.ListAdder = function(list_id){
		function add(element){
			$(list_id).append(element);
		}

		return {
			add: add
		};
	};

	module.PipelineStageElementFactory = function(options){
		BUILD_FAILED = 'Failure';
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
		var buildStatusWidget = $(".build_status"),
			passedClass = "builds-passed",
			BUILD_FAILED = 'Failure',
			failedBuildsListAdder = options.listAdder || new Builds.ListAdder("#failed_builds");
			runningBuildsListAdder = options.listAdder || new Builds.ListAdder("#running_builds");
			pipelineStageElementFactory = options.pipelineStageElementFactory || new Builds.PipelineStageElementFactory({});

		function update(data){
			var pipelineCount = 0;	
			buildStatusWidget.addClass(passedClass);
			for(pipelineCount; pipelineCount < data.items.length; pipelineCount++){
				var pipeline = data.items[pipelineCount];
				var pipelineStageElement = pipelineStageElementFactory.create(pipeline);

				if (pipeline.status === BUILD_FAILED){
					buildStatusWidget.removeClass(passedClass);
					failedBuildsListAdder.add(pipelineStageElement);
				}
				else{
					runningBuildsListAdder.add(pipelineStageElement);
				}
			}		
		};

		return {
			update : update
		}
	};



})(Builds);

