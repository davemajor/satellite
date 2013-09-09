module.exports = class Screen6View extends Backbone.View
    className: 'screen6'
    el: '.app'
    template: require 'views/templates/screen6'

    initialize: ->
        @render()

    render: ->
        $(@el).html @template

    close: ->
        $(@el).empty()
        @unbind()
        @undelegateEvents()

    next: ->
        Satellite.AppView.trigger 'next', {fromView: @}

    events:
        'click .action-next' : 'next'