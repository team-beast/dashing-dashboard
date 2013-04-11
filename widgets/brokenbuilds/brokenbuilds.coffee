class Dashing.Brokenbuilds extends Dashing.Widget
	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) ->
		if data.length == 0
			console.log("No pipelines, everything is green!")
		else
			console.log("got some pipelines")
