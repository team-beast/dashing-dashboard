class Dashing.Cycletime extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: -> 
    lineColor = "#00ff00"
    lineGraphFactory = new LineGraphFactory(@node,lineColor)
    @graph = new CycleTime.CycleTimeGraph(lineGraphFactory)
    points = @get('points') if @get('points')
    @graph.update(points) if points

  onData: (data) ->
      @graph.update(data.points) if @graph