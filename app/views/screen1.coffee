OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'
MapView = require 'views/map'


module.exports = class Screen1View extends Backbone.View
    className: 'screen1'
    template: require 'views/templates/screen1'
    el: '.app'

    initialize: ->
        @render()

    render: ->
        $(@el).html @template

        @perfectOrbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 100
                earthRotation: 60000
                center: {x: 150, y: 150}
        )
        $('#diagram1').html @perfectOrbit.render().el

        @slowOrbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 100
                speed: @perfectOrbit.model.get('speed') - 325.325
                earthRotation: 60000
                center: {x: 150, y: 150}
        )
        $('#diagram2').html @slowOrbit.render().el

        @map1 = new MapView
            zoom: 6
            orbit: @perfectOrbit.model
        $('#map1').html @map1.render().el

        @map2 = new MapView
            zoom: 6
            orbit: @slowOrbit.model
        $('#map2').html @map2.render().el

        @perfectOrbit.model.trigger 'change'
        @slowOrbit.model.trigger 'change'

        @slowOrbit.model.get('earthRotation')

    close: ->
        @map1.close()
        @map2.close()
        @slowOrbit.close()
        @perfectOrbit.close()
        $(@el).empty()
        @unbind()
        @undelegateEvents()
    next: ->
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'click .action-next': 'next'
