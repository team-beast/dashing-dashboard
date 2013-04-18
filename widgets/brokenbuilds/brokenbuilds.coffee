class Dashing.Brokenbuilds extends Dashing.Widget
	constructor: ->
		@buildStatus = new Builds.BuildStatus()
		super

	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) =>
		@buildStatus.update(data)