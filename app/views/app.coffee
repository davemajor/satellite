Screen1View = require 'views/screen1'
Screen2View = require 'views/screen2'
Screen3View = require 'views/screen3'
Screen4View = require 'views/screen4'
Screen5View = require 'views/screen5'

SessionModel = require 'models/session'

module.exports = class AppView extends Backbone.View
    className: 'app'

    initialize: ->
        # Satellite.Session = new SessionModel
        #     expression: '104h'
        new Screen1View()