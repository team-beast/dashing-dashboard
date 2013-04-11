(function(){
	module("Broken Builds");

	test("When broken builds receives no data then data with items Then broken builds widget does not have builds-passed class ",function(){
		var data0= { items: []},
			data1 = { items: [1,2,3]},
			builds = new Builds(),
			passedClass = "builds-passed",
			brokenBuildsWidget = $("#broken_builds_push");
			
		brokenBuildsWidget.addClass(passedClass);
		builds.update(data0);
		builds.update(data1);
		equal(brokenBuildsWidget.hasClass(passedClass),false);
	});
})();
