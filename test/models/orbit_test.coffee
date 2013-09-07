OrbitModel = require 'models/orbit'

describe 'OrbitModel', ->
    beforeEach ->
        @model = new OrbitModel()

    it 'should exist', ->
        expect(@model).to.be.ok
