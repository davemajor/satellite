OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen3View extends Backbone.View
    className: 'screen3'
    el: '.app'
    template: require 'views/templates/screen3'
    speed: 12566.370614359172

    initialize: ->
        @render()

    render: ->
        $(@el).html @template
        @orbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 120
                speed: @speed
                earthRotation: 60000
                center: {x: 150, y: 150}
        )
        $('#diagram').html @orbit.render().el
        @orbit.model.trigger 'change'