Screen1View = require 'views/screen1'
Screen2View = require 'views/screen2'
Screen3View = require 'views/screen3'
Screen4View = require 'views/screen4'
Screen5View = require 'views/screen5'
Screen6View = require 'views/screen6'

SessionModel = require 'models/session'

module.exports = class AppView extends Backbone.View
    className: 'app'

    initialize: ->
        @listenTo @, 'next', @handleNavigation, this
        Satellite.Session = new SessionModel
        @MainView = new Screen1View()

    handleNavigation: (evt) ->
        switch evt.fromView.className
            when "screen1" # Opening
                @MainView.close()
                @MainView = new Screen2View()
            when "screen2" # Guess the speed
                @MainView.close()
                @MainView = new Screen3View()
            when "screen3" # What information
                @MainView.close()
                @MainView = new Screen4View()
            when "screen4" # Calculate/Expression
                @MainView.close()
                @MainView = new Screen5View()
            when "screen5" # Slider
                @MainView.close()
                @MainView = new Screen6View()
            when "screen6" # Graph
                @MainView.close()
                @MainView = new Screen4View()