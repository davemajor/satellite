Screen1View = require 'views/screen1'

module.exports = class AppView extends Backbone.View
    className: 'app'

    initialize: ->
        @render()

    render: ->
        new Screen1View()