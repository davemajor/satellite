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
        $(@el).html @template
            speed: @speed
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
            'max': 300
            value: 240
        ).on('slide', (evt) =>
            @orbit.model.set
                altitude: evt.value / 2
        )

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') > @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') < @orbit.model.get('targetSpeed')