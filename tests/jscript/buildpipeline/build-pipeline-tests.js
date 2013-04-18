(function(){
	module("Build status");
	test("When one passed build Then passed class added to build status widget", function(){
		var buildData = { items: [{status: "Passed"}]},
			passedClass = "builds-passed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.removeClass(passedClass);
		new Builds.BuildStatus({failedBuildsList: StubListAdder,
								runningBuildsList: StubListAdder,
								pipelineStageElementFactory: stubPipelineStageElementFactory})
								.update(buildData);
		equal(buildStatusWidget.hasClass(passedClass), true);
	});


	test("When failed and updated, Then failed list cleared",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Failure"},
			buildData = { 
				items: [pipeline]
			},
			clearCalled = false,
			fakeListAdder = {
				add: function(){},
				clear: function(){
					clearCalled = true;
				}
			};
		new Builds.BuildStatus({failedBuildsList: fakeListAdder,
								runningBuildsList: StubListAdder,
								pipelineStageElementFactory: stubPipelineStageElementFactory})
								.update(buildData)
		equal(clearCalled,true);
	});

	test("When building and updated, Then running list cleared",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Building"},
			buildData = { 
				items: [pipeline]
			},
			clearCalled = false,
			fakeListAdder = {
				add: function(){},
				clear: function(){
					clearCalled = true;
				}
			};
		new Builds.BuildStatus({failedBuildsList: StubListAdder,
								runningBuildsList: fakeListAdder,
								pipelineStageElementFactory: stubPipelineStageElementFactory})
								.update(buildData)
		equal(clearCalled,true);
	});


})();


var StubListAdder = {
	add : function(){},
	clear: function(){}
};

var stubPipelineStageElementFactory = {
	create: function(){}
};

var StubFailedPipelineStageElementFactory = function(){
	function create(pipeline){
		return "<li><span class='pipeline-name'>"+ pipeline.pipeline_name +"</span> <span class='pipeline-stage'>"+pipeline.stage_name+"</span></li>"	
	}

	return {
		create: create,
	};
	
};
