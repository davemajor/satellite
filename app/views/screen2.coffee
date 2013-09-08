OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen2View extends Backbone.View
    className: 'screen2'
    el: '.app'
    template: require 'views/templates/screen2'
    tries: 5
    speed: 12566.370614359172

    initialize: ->
        @render()
        @updateStatus()

    render: ->
        $(@el).html @template
            tries: @tries
            speed: @speed

        @orbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 120
                speed: @speed
                earthRotation: 60000
                center: {x: 150, y: 150}
        )
        $('#diagram').html @orbit.render().el
        @orbit.model.trigger 'change'

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') > @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') < @orbit.model.get('targetSpeed')

    didChangeSpeed: ->
        if parseFloat($('input[name="speed"]').val()) != @speed
            $('button').removeAttr 'disabled'
        else
            $('button').attr 'disabled', 'true'

    updateOrbit: ->
        $('button').attr 'disabled', 'true'
        @speed = parseFloat($('input[name="speed"]').val())
        @orbit.model.set
            speed: @speed
        @updateStatus()
        @tries--
        $('.tries').text @tries

    events:
        'change input[name="speed"]': 'didChangeSpeed'
        'keyup input[name="speed"]': 'didChangeSpeed'
        'click button' : 'updateOrbit'