OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen2View extends Backbone.View
    className: 'screen2'
    el: '.app'
    template: require 'views/templates/screen2'
    tries: 5

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
                speed: 725.2759432379867
                earthRotation: 60000
                center: {x: 150, y: 150}
        )
        $('#diagram').html @orbit.render().el
        @orbit.model.trigger 'change'

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') >  @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') <  @orbit.model.targetOrbitSpeedMPH

    didChangeSpeed: (evt) ->
        if evt.hasOwnProperty('which') and evt.which == 13 and !$('.action-update-orbit').attr('disabled')?
            $('.action-update-orbit').click()
        if parseFloat($('input[name="speed"]').val()) != @speed and isFinite(parseFloat($('input[name="speed"]').val()))
            $('.action-update-orbit').removeAttr 'disabled'
        else
            $('.action-update-orbit').attr 'disabled', 'true'

    updateOrbit: ->
        $('.action-update-orbit').attr 'disabled', 'true'
        @speed = parseFloat($('input[name="speed"]').val())
        @orbit.model.set
            speed: @speed
        @updateStatus()
        @tries--
        if @tries == 1
            $('.tries').text @tries + ' more try'
        else
            $('.tries').text @tries + ' more tries'
        if @tries == 0
            $('.nav-controls').addClass('readyForNext')

    close: ->
        # @map1.close()
        @orbit.close()
        $(@el).empty()
        @unbind()
        @undelegateEvents()

    next: ->
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'change input[name="speed"]': 'didChangeSpeed'
        'keyup input[name="speed"]': 'didChangeSpeed'
        'click .action-update-orbit' : 'updateOrbit'
        'click .action-next' : 'next'