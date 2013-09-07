Screen1View = require 'views/screen1'

describe 'Screen1View', ->
    beforeEach ->
        @view = new Screen1View()

    it 'should exist', ->
        expect(@view).to.be.ok
