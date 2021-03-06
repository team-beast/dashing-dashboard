class Dashing.Performancecounter extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: ->    
    container = $(@node).parent()    
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: 'line'
      series: [
        {
        color: "#00ff00",
        data: [{x:0, y:0}]
        }
      ]
    )
    y_axis = new Rickshaw.Graph.Axis.Y(
      graph: @graph, 
      tickFormat: Rickshaw.Fixtures.Number.formatKMBT)

    points = @get('points') if @get('points')
    this.renderPoints points

  onData: (data) ->
    if @graph
      this.renderPoints data.points

  renderPoints: (points) ->
    @graph.series[0].data = points
    maxY = this.getMax(points) * 2
    @graph.max = maxY
    @graph.render()   

  getMax: (data) ->
    heights = data.map (point) -> point.y if data?
    Math.max.apply null, heights