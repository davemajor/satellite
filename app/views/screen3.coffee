OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'
MapView = require 'views/map'

module.exports = class Screen3View extends Backbone.View
    className: 'screen3'
    el: '.app'
    template: require 'views/templates/screen3'
    speed: 725.2759432379867

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

        @map = new MapView
            zoom: 6
            orbit: @orbit.model
        $('#map').html @map.render().el

        @orbit.model.trigger 'change'

    didChangeTextarea: (evt) ->
        if $(evt.target).val().length > 0
            $('.action-next').removeAttr 'disabled'
        else
            $('.action-next').attr 'disabled', true

    close: ->
        @map.close()
        @orbit.close()
        $(@el).empty()
        @unbind()
        @undelegateEvents()

    next: ->
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'keyup .useful-information': 'didChangeTextarea'
        'click .action-next' : 'next'