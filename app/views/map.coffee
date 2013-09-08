module.exports = class MapView extends Backbone.View
    className: 'map'
    template: require 'views/templates/map'

    drift: 0

    initialize: (options) ->
        @lat = 51.5072
        @lng = 0.1275
        @updateTime = 100
        @deltaTime = (new Date).getTime()

        @mapOptions =
            zoom: if options? and options.zoom? then options.zoom else 8
            disableDefaultUI: true
            scrollwheel: false
            navigationControl: false
            mapTypeControl: false
            scaleControl: false
            draggable: false
            center: new google.maps.LatLng(@lat, @lng)
            mapTypeId: google.maps.MapTypeId.ROADMAP
        @render()
        _.bindAll this
        if options? and options.orbit
            @orbit = options.orbit
            @earthRotation = @orbit.get('earthRotation')
            @orbitTime = @orbit.get('orbitTime')
            @listenTo @orbit, 'change', @updateSpeed, this

    updateSpeed: ->
        @speed = @orbit.get('speed')
        google.maps.event.addListenerOnce @map, 'idle', =>
            console.log "READY"
            @pan()

    render: ->
        $(@el).html @template
        @map = new google.maps.Map(@el, @mapOptions)
        @

    pan: ->
        if @speed == @orbit.get('targetSpeed')
            return
        console.log @orbitTime
        console.log @earthRotation
        time = (new Date).getTime()
        delta = time - @deltaTime
        adjustedRotation = (@orbitTime / @earthRotation) * @earthRotation
        movement = (delta / @orbitTime) * 360

        @lng -= movement
        if @lng > 180
            @lng -= 360
        else if @lng < -180
            @lng += 360

        @map.panTo new google.maps.LatLng(@lat, @lng)
        @deltaTime = time

        setTimeout @pan, @updateTime