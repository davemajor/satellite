OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen5View extends Backbone.View
    className: 'screen3'
    el: '.app'
    template: require 'views/templates/screen5'

    initialize: ->
        @render()

    render: ->
        params = {
            speed: Satellite.Session.get('speed')
        }
        if Satellite.Session.get('expression')?
            params.expression = Satellite.Session.get('expression')
        $(@el).html @template params
        $('.mathquill').mathquill()

        @orbit = new OrbitDiagramView(
            model: new OrbitModel
                altitude: 120
                speed: Satellite.Session.get('speed')
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
        if Satellite.Session.get('expression')?
            calc = new Calc(Satellite.Session.get('expression'))
            speed = calc.eval(value)
        else
            speed = Satellite.Session.get('speed')
        @orbit.model.set
            altitude: value
            speed: speed

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') >  @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') <  @orbit.model.targetOrbitSpeedMPH

    close: ->
        # @map1.close()
        @orbit.close()
        $(@el).empty()
        @unbind()
        @undelegateEvents()
    next: ->
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'click .action-next': 'next'