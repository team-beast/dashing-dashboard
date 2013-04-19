class Dashing.Brokenbuilds extends Dashing.Widget
	constructor: ->
		super
		options = 	
			failedBuildsList            : new Builds.PipelinesList("#failed_builds")
			runningBuildsList           : new Builds.PipelinesList("#running_builds")
		@buildStatus = new Builds.BuildStatus(options)
		

	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) =>
		@buildStatus.update(data)