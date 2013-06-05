(function(){
	module("Build status");
	test("When one failed build Then failed class added to build status widget", function(){
		var buildData = [{status: "Failure"}],
			failedClass = "builds-failed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.removeClass(failedClass);
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(StubListAdder,StubListAdder),
								failedBuildsList: StubListAdder,
								runningBuildsList: StubListAdder})
								.update(buildData);
		equal(buildStatusWidget.hasClass(failedClass), true);
	});

	test("When one Building build with last_build_status of failed Then failed class added to build status widget", function(){
		var buildData = [{status: "Building", last_build_status: "Failure"}],
			failedClass = "builds-failed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.removeClass(failedClass);
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(StubListAdder,StubListAdder),
								failedBuildsList: StubListAdder,
								runningBuildsList: StubListAdder})
								.update(buildData);
		equal(buildStatusWidget.hasClass(failedClass), true);
	});


	test("When failed, Then failed list gets correct pipeline",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Failure"},
			buildData = [pipeline],
			failedBuildList = $('#failed_builds'),
			templatedPipeline,
			mockListAdder = {
				add : function(pipeline){
					templatedPipeline = pipeline;
				},
				clear: function(){}
			};		
		failedBuildList.empty();
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(mockListAdder,StubListAdder),
								failedBuildsList: mockListAdder,
								runningBuildsList: StubListAdder})
								.update(buildData);
		equal(templatedPipeline, pipeline);
	});

	test("When building, Then building list contains correct element",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Building"},
			buildData = [pipeline],
			failedBuildList = $('#failed_builds'),
			templatedPipeline,
			mockListAdder = {
				add : function(pipeline){
					templatedPipeline = pipeline;
				},
				clear: function(){}
			};		
		failedBuildList.empty();

		new Builds.BuildStatus({buildLists: new Builds.BuildLists(StubListAdder,mockListAdder),
								failedBuildsList: StubListAdder,
								runningBuildsList: mockListAdder})
								.update(buildData);
		equal(templatedPipeline, pipeline);
	});

	test("When failed and updated, Then failed list cleared",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Failure"},
			buildData = [pipeline],
			clearCalled = false,
			fakeListAdder = {
				add: function(){},
				clear: function(){
					clearCalled = true;
				}
			};
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(fakeListAdder,StubListAdder),
								failedBuildsList: fakeListAdder,
								runningBuildsList: StubListAdder})
								.update(buildData)
		equal(clearCalled,true);
	});

	test("When building and updated, Then running list cleared",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Building"},
			buildData = [pipeline],
			clearCalled = false,
			fakeListAdder = {
				add: function(){},
				clear: function(){
					clearCalled = true;
				}
			};
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(StubListAdder,fakeListAdder),
								failedBuildsList: StubListAdder,
								runningBuildsList: fakeListAdder})
								.update(buildData)
		equal(clearCalled,true);
	});

	test("When failed previously And then updated with non failing Then failed class removed", function(){
		var buildData = [{status: "Failure"}],
			failedClass = "builds-failed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.addClass(failedClass);
		new Builds.BuildStatus({buildLists: new Builds.BuildLists(StubListAdder,StubListAdder),
								failedBuildsList: StubListAdder,
								runningBuildsList: StubListAdder})
								.update([{}]);

		equal(buildStatusWidget.hasClass(failedClass), false);
	});





})();


var StubListAdder = {
	add : function(){},
	clear: function(){}
};

var stubPipelineStageElementFactory = {
	create: function(){}
};
