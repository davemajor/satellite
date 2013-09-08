module.exports = class OrbitModel extends Backbone.Model

    initialize: ->
        @listenTo @, 'change', @setup
        @setup()

    setup: ->
        @calcDrift()
        @calcTargetSpeed()

    calcDrift: ->
        altitude = @get('altitude')
        speed = @get('speed') / 1000000
        earthRotation = @get('earthRotation')

        orbitDistance = (2 * Math.PI) * altitude
        orbitTime = orbitDistance / speed
        @set (
            orbitTime: orbitTime
            drift: orbitTime - earthRotation
        )

    calcTargetSpeed: ->
        altitude = @get('altitude')
        earthRotation = @get('earthRotation')
        orbitDistance = (2 * Math.PI) * altitude

        speed = orbitDistance / earthRotation
        @set (
            targetSpeed: speed * 1000000
        )