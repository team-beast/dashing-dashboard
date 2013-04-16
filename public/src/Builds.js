(function(){
	this.BuildStatus = function(){
		var buildStatusWidget = $(".build_status"),
			passedClass = "builds-passed",
			BUILD_FAILED = 'Failed';


		function update(data){
			var pipelineCount = 0;	
			buildStatusWidget.addClass(passedClass);
			for(pipelineCount; pipelineCount < data.items.length; pipelineCount++){
				if (data.items[pipelineCount].last_build_status === BUILD_FAILED){
					buildStatusWidget.removeClass(passedClass);
				}
			}		
		};

		return {
			update : update
		}
	};
})();