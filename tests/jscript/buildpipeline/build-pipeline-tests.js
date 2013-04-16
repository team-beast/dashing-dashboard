(function(){
	module("Build status");

	test("When one passed build Then passed class added to build status widget", function(){
		var buildData = { items: [{last_build_status: "Passed"}]},
			passedClass = "builds-passed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.removeClass(passedClass);
		new BuildStatus().update(buildData);
		equal(buildStatusWidget.hasClass(passedClass), true);
	});

	test("When one failed build Then passed class not on status widget", function(){
		var buildData = { items: [{last_build_status: "Failed"}]},
			passedClass = "builds-passed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.addClass(passedClass);
		new BuildStatus().update(buildData);
		equal(buildStatusWidget.hasClass(passedClass), false);
	});

	test("When one failed and one passed build, Then passed class not on build status widget", function(){
		var buildData = { 
				items: [{last_build_status: "Passed"}, {last_build_status: "Failed"}]
			},
			passedClass = "builds-passed",
			buildStatusWidget = $(".build_status");
		buildStatusWidget.addClass(passedClass);
		new BuildStatus().update(buildData);
		equal(buildStatusWidget.hasClass(passedClass), false);
	});

})();
