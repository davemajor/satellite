###
    The earth is 110 pixels in diameter/ 55 in radius against 3963 miles in radius

    The earth rotates at 1037.5109738480298 mph with a circumference of 24900.26337235271517 miles

    altitude pixels are worth 2 miles
###

module.exports = class OrbitModel extends Backbone.Model

    earthRotationDuration: 60000
    earthRotationMPH: 1037.5109738480298

    initialize: ->
        @listenTo @, 'change', @setup
        @setup()

    setup: ->
        @altitudeMiles = @get('altitude') / 2
        @totalAltitudeMiles = 3963 + @altitudeMiles
        @orbitCircumferenceMiles = (2 * Math.PI) * @totalAltitudeMiles
        @orbitSpeedMPH = @orbitCircumferenceMiles / 24
        @targetOrbitSpeedMPH = @orbitCircumferenceMiles / 24

        if @get('speed')?
            @orbitSpeedMPH = @attributes.speed
        else
            @attributes.speed = @orbitSpeedMPH

        @orbitDuration = ((@orbitCircumferenceMiles / @orbitSpeedMPH) / 24) * 60000