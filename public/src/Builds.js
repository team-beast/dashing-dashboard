var Builds = Builds || {};
(function(module){

	module.PipelinesList = function(list_id,template_id){
		function clear(element){
			$(list_id).empty();
		}
		function add(pipeline){
			var source   = $(template_id).html();
			var template = Handlebars.compile(source);
			$(list_id).append(template(pipeline));
		}

		return {
			add: add,
			clear: clear
		};
	};

	module.BuildLists = function(failedBuildsList,runningBuildsList){
		
		function clear(){
			failedBuildsList.clear();
			runningBuildsList.clear();
		}

		function add(pipeline){
			if(pipeline.status === 'Failure'){
				failedBuildsList.add(pipeline);
			}
			else{
				runningBuildsList.add(pipeline);
			}
		}

		return{
			clear: clear,
			add: add
		};
	};


	module.BuildStatus = function(options){
		var FAILED_CLASS = "builds-failed",
			BUILD_STATUS_WIDGET = $(".build_status"),
			buildLists = options.buildLists,
			buildStatusFailureSpecification = new BuildStatusFailureSpecification();
		
		function update(pipelines){
			clearList();
			createList(pipelines);
		};

		function createList(pipelines){
			var pipelineCount = 0;
			for(pipelineCount; pipelineCount < pipelines.length; pipelineCount++){
				var pipeline = pipelines[pipelineCount];
					if(buildStatusFailureSpecification.isSatisfiedBy(pipeline)){
						BUILD_STATUS_WIDGET.addClass(FAILED_CLASS);
					}
					buildLists.add(pipeline);
			}
		}

		function buildStatusFailed(pipeline){
			return pipeline.status === BUILD_FAILED || pipeline.last_build_status === BUILD_FAILED
		}

		function clearList(){
			BUILD_STATUS_WIDGET.removeClass(FAILED_CLASS);
			buildLists.clear();
		}


		return {
			update : update
		};
	};

	var BuildStatusFailureSpecification = function(){
		BUILD_FAILED = 'Failure';
		function isSatisfiedBy(pipeline){
			return pipeline.status === BUILD_FAILED || pipeline.last_build_status === BUILD_FAILED;
		}

		return{
			isSatisfiedBy: isSatisfiedBy
		};
	};



})(Builds);

