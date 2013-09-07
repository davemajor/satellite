AppView = require 'views/app'

describe 'AppView', ->
    beforeEach ->
        @view = new AppView()

    it 'should exist', ->
        expect(@view).to.be.ok
