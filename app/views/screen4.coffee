OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'

module.exports = class Screen4View extends Backbone.View
    className: 'screen4'
    el: '.app'
    template: require 'views/templates/screen4'
    template2: require 'views/templates/screen4alt'
    speed: 725.2759432379867
    latex: undefined
    altitude: 120

    initialize: ->
        @render()

    render: ->
        orbitModel = new OrbitModel
            altitude: 120
            speed: @speed
            earthRotation: 60000
            center: {x: 200, y: 200}

        if Satellite.Session.get('speed')?
            $(@el).html @template2 orbitModel.attributes
        else
            $(@el).html @template orbitModel.attributes

        @orbit = new OrbitDiagramView(
            model: orbitModel
        )
        $('#diagram').html @orbit.render().el
        @orbit.model.on 'change', @updateStatus, this
        @orbit.model.trigger 'change'

        $('.speed-expression').mathquill('editable')
        @updateExpression()

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') >  @orbit.model.targetOrbitSpeedMPH
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') <  @orbit.model.targetOrbitSpeedMPH

    updateExpression: ->
        latex = $('.speed-expression').mathquill('latex')
        invalid = false
        if latex == @latex
            return
        else if latex.length == 0
            invalid = true
        else
            exp = new Calc(latex)
            if exp.valid
                if Satellite.Session.get('speed')?
                    evaled = exp.eval(@altitude)
                else
                    evaled = exp.eval()
                if evaled != undefined and !_.isNaN evaled
                    @speed = evaled
                    $('.calculated-speed .speed').text(evaled.toFixed(2))
                else
                    invalid = true
            else
                invalid = true
        $('.speed-expression').toggleClass('invalid', invalid)
        $('.calculated-speed').toggle(!invalid)
        if invalid
            $('.action-update-speed').attr 'disabled','true'
        else
            $('.action-update-speed').removeAttr 'disabled'

    updateOrbit: ->
        @orbit.model.set
            speed: @speed
        @updateStatus()

    close: ->
        # @map1.close()
        @orbit.close()
        $(@el).empty()
        @unbind()
        @undelegateEvents()
    next: ->
        if Satellite.Session.get('speed')?
            # Second time round, so save expression
            Satellite.Session.set
                expression: $('.speed-expression').mathquill('latex')
        else
            Satellite.Session.set
                speed: @speed
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'keyup .speed-expression': 'updateExpression'
        'click .action-update-speed': 'updateOrbit'
        'click .action-next': 'next'