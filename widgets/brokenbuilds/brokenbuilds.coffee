class Dashing.Brokenbuilds extends Dashing.Widget
	constructor: ->
		super
		failedBuildsList = new Builds.PipelinesList("#failed_builds","#failed-build-template")
		runningBuildsList = new Builds.PipelinesList("#running_builds","#building-build-template")
		buildsList = new Builds.BuildLists(failedBuildsList,runningBuildsList)
		options = 	
			buildLists : buildsList
		@buildStatus = new Builds.BuildStatus(options)
		@orderedPipelineFactory = new OrderedPipelineFactory()
		

	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) =>
		pipelines = @orderedPipelineFactory.create(data)
		@buildStatus.update(pipelines)