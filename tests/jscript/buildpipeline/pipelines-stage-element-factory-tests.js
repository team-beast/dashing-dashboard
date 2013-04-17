(function(){
	module("Pipeline Stage Element Factory Tests");

	test("When Building, Then BuildingTemplate Used to create Element",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Building"},
			stubBuildingElementTemplate = new StubBuildingElementTemplate();
			expectedResult = stubBuildingElementTemplate.build(pipeline),
			pipelineStageElementFactory = new Builds.PipelineStageElementFactory({buildingElementTemplate: stubBuildingElementTemplate});
		result = pipelineStageElementFactory.create(pipeline);
		equal(result,expectedResult);
	});

	test("When Failed, Then BuildingTemplate Used to create Element",function(){
		var pipeline = {pipeline_name: "bob", stage_name: "fred", status: "Failure"},
			stubFailedElementTemplate = new StubFailedElementTemplate();
			expectedResult = stubFailedElementTemplate.build(pipeline),
			pipelineStageElementFactory = new Builds.PipelineStageElementFactory({failedElementTemplate: stubFailedElementTemplate,});
		result = pipelineStageElementFactory.create(pipeline);
		equal(result,expectedResult);
	});
})();

var StubBuildingElementTemplate = function(){
	function build(pipeline){
		return "blah " + pipeline.pipeline_name + "blah" + pipeline.stage_name
	}

	return{
		build: build
	};
};

var StubFailedElementTemplate = function(){
	function build(pipeline){
		return "blah " + pipeline.pipeline_name + "blah" + pipeline.stage_name
	}

	return{
		build: build
	};
};