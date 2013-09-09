# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'routers/main'
@Satellite ?= {}

AppView = require 'views/app'

$ ->
    # Initialize Backbone History
    Backbone.history.start pushState: yes
    Satellite.AppView = new AppView
