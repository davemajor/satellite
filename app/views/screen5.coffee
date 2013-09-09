OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen5View extends Backbone.View
    className: 'screen3'
    el: '.app'
    template: require 'views/templates/screen5'
    speed: 12566.370614359172

    initialize: ->
        @render()

    render: ->
        params = {
            speed: @speed
        }
        if Satellite.Session?
            params.expression = Satellite.Session.get('expression')
        $(@el).html @template params
        $('.mathquill').mathquill()

        @orbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 120
                speed: @speed
                earthRotation: 60000
                center: {x: 200, y: 200}
        )
        $('#diagram').html @orbit.render().el
        @orbit.model.on 'change', @updateStatus, this
        @orbit.model.trigger 'change'

        $('.slider').slider(
            'orientation': 'vertical'
            'min': 150
            'max': 350
            value: 240
        ).on('slide', (evt) =>
            @updateOrbit(evt.value / 2)
        )

    updateOrbit: (value) ->
        debugger
        if Satellite.Session?
            calc = new Calc(Satellite.Session.get('expression'))
            speed = calc.eval(value)
        else
            speed = @speed
        @orbit.model.set
            altitude: value
            speed: speed

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') > @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') < @orbit.model.get('targetSpeed')