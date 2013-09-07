module.exports = class OrbitModel extends Backbone.Model

    initialize: ->
        @listenTo @, 'change', @calcDrift
        @calcDrift()

    calcDrift: ->
        altitude = @get('altitude')
        speed = @get('speed')
        earthRotation = @get('earthRotation')

        orbitDistance = (2 * Math.PI) * altitude
        orbitTime = orbitDistance * speed
        @set (
            orbitTime: orbitTime
            drift: orbitTime - earthRotation
        )