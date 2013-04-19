class Dashing.Brokenbuilds extends Dashing.Widget
	constructor: ->
		super
		options = 	
			failedBuildsList            : new Builds.PipelinesList("#failed_builds","#failed-build-template")
			runningBuildsList           : new Builds.PipelinesList("#running_builds","#building-build-template")
		@buildStatus = new Builds.BuildStatus(options)
		

	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) =>
		@buildStatus.update(data)