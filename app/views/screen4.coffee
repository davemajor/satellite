OrbitDiagramView = require 'views/orbitDiagram'
OrbitModel = require 'models/orbit'
# Calc = require 'lib/calc'

module.exports = class Screen4View extends Backbone.View
    className: 'screen4'
    el: '.app'
    template: require 'views/templates/screen4'
    speed: 12566.370614359172
    latex: undefined
    altitude: 120

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

        $('.speed-expression').mathquill('editable')
        @updateExpression()

    updateStatus: ->
        $('#orbitStatus').toggleClass 'perfect', @orbit.model.get('speed') == @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'toofast', @orbit.model.get('speed') > @orbit.model.get('targetSpeed')
        $('#orbitStatus').toggleClass 'tooslow', @orbit.model.get('speed') < @orbit.model.get('targetSpeed')

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
                evaled = exp.eval(@altitude)
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
            $('button').attr 'disabled','true'
        else
            $('button').removeAttr 'disabled'

    updateOrbit: ->
        @orbit.model.set
            speed: @speed * 1000000
        @updateStatus()

    events:
        'keyup .speed-expression': 'updateExpression'
        'click button': 'updateOrbit'