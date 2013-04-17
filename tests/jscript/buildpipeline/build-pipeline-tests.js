(function(){
	module("Build status");

	test("When one passed build Then passed class added to build status widget", function(){
		var buildData = { items: [{status: "Passed"}]},
			passedClass = "builds-passed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.removeClass(passedClass);
		new Builds.BuildStatus({}).update(buildData);
		equal(buildStatusWidget.hasClass(passedClass), true);
	});


	test("When failed, Then failed list contains correct element",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Failure"},
			buildData = { 
				items: [pipeline]
			},
			failedBuildList = $('#failed_builds'),
			stubFailedPipelineStageElementFactory = new StubFailedPipelineStageElementFactory(),
			expectedElement = stubFailedPipelineStageElementFactory.create(pipeline),
			appendedElement,
			mockListAdder = {
				add : function(element){
					appendedElement = element;
				}
			};		
		failedBuildList.empty()
		new Builds.BuildStatus({pipelineStageElementFactory: stubFailedPipelineStageElementFactory, listAdder: mockListAdder}).update(buildData);
		equal(appendedElement,expectedElement);
	});

	test("When building, Then running builds list contains correct element",function(){
		var buildData = { 
				items: [{pipeline_name: "bob", stage_name: "fred", status: "Building"}]
			},
			failedBuildList = $('#running_builds'),
			stubFailedPipelineStageElementFactory = new StubFailedPipelineStageElementFactory();	
		failedBuildList.empty()
		new Builds.BuildStatus({pipelineStageElementFactory: stubFailedPipelineStageElementFactory}).update(buildData);
		
		equal(failedBuildList.find('li').size(),1);
	});

	test("When failed, Then failed list contains correct element",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Building"},
			buildData = { 
				items: [pipeline]
			},
			failedBuildList = $('#failed_builds'),
			stubFailedPipelineStageElementFactory = new StubFailedPipelineStageElementFactory(),
			expectedElement = stubFailedPipelineStageElementFactory.create(pipeline),
			appendedElement,
			mockListAdder = {
				add : function(element){
					appendedElement = element;
				}
			};		
		failedBuildList.empty()
		new Builds.BuildStatus({pipelineStageElementFactory: stubFailedPipelineStageElementFactory, listAdder: mockListAdder}).update(buildData);
		equal(appendedElement,expectedElement);
	});
})();



var StubFailedPipelineStageElementFactory = function(){
	function create(pipeline){
		return "<li><span class='pipeline-name'>"+ pipeline.pipeline_name +"</span> <span class='pipeline-stage'>"+pipeline.stage_name+"</span></li>"	
	}
	return {
		create: create
	};
	
};
