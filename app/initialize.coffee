# Load App Helpers
require 'lib/helpers'

# Initialize Router
require 'routers/main'

AppView = require 'views/app'

$ ->
    # Initialize Backbone History
    Backbone.history.start pushState: yes
    app = new AppView
