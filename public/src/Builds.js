var Builds = function(){
	var brokenBuildsWidget = $(".broken_builds_push"),
		passedClass = "builds-passed";


	function update(data){
		//if items contains one or more broken builds

		console.log(data.items[0])
		if(data.items.length > 0){
			brokenBuildsWidget.removeClass(passedClass)
		}
		else{
			brokenBuildsWidget.addClass(passedClass);
		}
	};

	return {
		update : update
	}
};