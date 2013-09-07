module.exports = class OrbitDiagramView extends Backbone.View
    className: 'orbitDiagram'
    template: require 'views/templates/orbitDiagram'
    

    initialize: ->
        @earthRotation = @model.get('earthRotation')
        @speed = @model.get('speed')
        @center = @model.get('center')
        @altitude = @model.get('altitude')

        @render()
        _.bindAll @
        @listenTo @model, 'change', =>
            @setupOrbit()
            @animate()

    setupOrbit: ->
        @altitude = @model.get('altitude')

        ellipse = "M" + (@center.x - @altitude) +
        "," + @center.y + " a " + @altitude +
        "," + @altitude + " 0 1,1 0,0.1"

        if @orbit?
            @orbit.attr('path', ellipse)
        else
            @orbit = @paper.path(ellipse).attr(
                "stroke-width": 3
                "stroke": "#979797"
                'stroke-dasharray':'-'
            )

    animate: ->
        @earth.stop()
        @satellite.stop()

        distance = @orbit.getTotalLength()

        @satellite.animateAlong(
            @paper
            @orbit
            distance * @speed
            Infinity
            this
        )
        @earthAnim = Raphael.animation(
            transform: "r360" + "," + @center.x + "," + @center.y, @earthRotation
        )

        @earth.animate @earthAnim.repeat(Infinity)

    render: ->
        $(@el).html @template
        @paper = Raphael(@el, @center.x * 2, @center.x * 2)
        @earth = undefined

        focus = Math.pow(@altitude * @altitude - @altitude * @altitude, 0.5)
        planet = @paper.image(
            "images/earth.png",
            @center.x - focus - (125/2)
            @center.y - (125/2)
            125
            125
        ).attr(
            stroke: 0
            fill: "blue"
        )

        pole = @paper.path("M{0} {1} L {2} {0}", @center.x, @center.y, 50).attr(
            "stroke-width": 1
            "stroke": "#979797"
            'stroke-dasharray':'.'
        )
        @earth = @paper.set()
        @earth.push planet, pole

        @satellite = @paper.circle(@center.x - @altitude, @center.y, 10).attr(
            stroke: 0
            fill: "#CCC"
        )
        @

    Raphael.el.animateAlong = (paper, path, duration, repetitions, context) ->
        element = this
        element.path = path
        element.pathLen = element.path.getTotalLength()
        duration = if typeof duration is "undefined"
            5000
        else
            duration
        repetitions = if typeof repetitions is "undefined"
            1
        else
            repetitions
        paper.customAttributes.along = (v) =>
            point = path.getPointAtLength(v * @pathLen)
            attrs =
                cx: point.x
                cy: point.y

            @rotateWith and (attrs.transform = "r" + point.alpha)
            attrs
        if context.earth.attr()[0].attrs.hasOwnProperty("transform")
            currentRot = context.earth.attr()[0].attrs.transform[0][1]
        else
            currentRot = 0
        along = (currentRot / 360)
        element.attr along: along
        moonanim = Raphael.animation(
            along: 1
            duration
        )
        element.animateWith @earth, @earthAnim, moonanim.repeat(repetitions)