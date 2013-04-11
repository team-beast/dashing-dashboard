class Dashing.Brokenbuilds extends Dashing.Widget
	ready: ->
		if @get('unordered')
			$(@node).find('ol').remove()
		else
			q$(@node).find('ul').remove()
			console.log("broken build ready")
	onData: (data) ->
		console.log("got some data")
