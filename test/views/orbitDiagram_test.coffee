OrbitDiagramView = require 'views/orbitDiagram'

describe 'OrbitDiagramView', ->
    beforeEach ->
        @view = new OrbitDiagramView()

    it 'should exist', ->
        expect(@view).to.be.ok
