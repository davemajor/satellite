SessionModel = require 'models/session'

describe 'SessionModel', ->
    beforeEach ->
        @model = new SessionModel()

    it 'should exist', ->
        expect(@model).to.be.ok
