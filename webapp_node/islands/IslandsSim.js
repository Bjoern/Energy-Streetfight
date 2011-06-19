require('underscore')

function IslandsSim(
    mapWidth,
    mapHeight,
    fogOfWarChunkSize,
    numberOfIslands,
    minIslandSize,
    maxIslandSize,
    numberOfProblemTypes,
    numberOfProblemOccurances,
    resourceTypesPerProblem,
    numberOfShips,
    playersPerWeek,
    isMassStart,
    shipCapacity,
    fractionOfExplorers
){
    this.mapWidth = mapWidth
    this.mapHeight = mapHeight
    this.fogOfWarChunkSize = fogOfWarChunkSize
    this.numberOfIslands = numberOfIslands
    this.minIslandSize = minIslandSize
    this.maxIslandSize = maxIslandSize
    this.numberOfProblemTypes = numberOfProblemTypes
    this.numberOfProblemOccurances = numberOfProblemOccurances
    this.resourceTypesPerProblem = resourceTypesPerProblem
    this.numberOfShips = numberOfShips
    this.playersPerWeek = playersPerWeek
    this.isMassStart = isMassStart
    this.shipCapacity = shipCapacity 
    this.fractionOfExplorers = fractionOfExplorers

    this.maxResources = numberOfProblemTypes*resourceTypesPerProblem
    this.turn = 0
    this.problemsSolved = 0

    this.initIslands()
    this.initProblems()
    this.initShips()

}

IslandsSim.prototype = {

    initIslands: function() {

	this.islands = _.map(_.range(this.numberOfIslands), function(index) {
		//var attempt = 0
		//while (attempt < 100) {
		var island = {
		    x: Math.abs(Math.random()*this.mapWidth),
		    y: Math.abs(Math.random()*this.mapHeight),
		    width: this.minIslandSize + Math.abs(Math.random()*(this.maxIslandSize - this.minIslandSize)),
		    items: [],
		    problem: null,
		    isHidden: true
		}
		//TODO check distance to nearest island - avoid collisions
		return island
	    }, this);
    },

    placeResource: function(resource){
	var candidateIslands = _.select(this.islands, function(island){return island.items.length < 2 && _.indexOf(island.items, resource) < 0})

	var island = this.getRandomIsland(candidateIslands)

	island.items.push(resource)
    },

    placeProblem: function(problem, placeResources){

	var items = [problem, "a"+problem]
	if (this.resourceTypesPerProblem == 2) {
	    items.push("b"+problem)
	}

	var candidateIslands = _.select(this.islands, function(island){return island.problem == null})

	var island = this.getRandomIsland(candidateIslands)

	island.problem = items

	if(placeResources){
	    var resources = _.rest(items)
	    _.each(resources, function(resource){this.placeResource(resource)}, this)
	}

	return island
    },

    initProblems: function(){
	_.each(_.range(this.numberOfProblemOccurances*this.numberOfProblemTypes), function(problem) {
		this.placeProblem(Math.floor(problem/this.numberOfProblemTypes), true)
	    }, this);
    },	

    initShips: function(){
	this.ships = _.map(_.range(this.numberOfShips), function(shipIndex){

	    var x = 0, y = 0
	    if(!this.isMassStart) {
		x = Math.abs(Math.random()*this.mapWidth)
		y = Math.abs(Math.random()*this.mapHeight)
	    }
	    var type = Math.random() < this.fractionOfExplorers ? 'explorer' : 'solver'
	    return {x: x, y: y, speed: 5, destination: null, direction: null, cargo: [], type: type, problemToSolve: null}
	}, this);
    },

    getRandomIsland: function(islands) {
	var island = islands && islands.length > 0 ? islands[Math.floor(Math.abs(Math.random()*islands.length))] : null
	return island
    },

    isShipOnIsland: function(ship, island){
	return ship && island && this.distance(ship.x, ship.y, island.x, island.y) <= island.width/2
    },

    distance: function(x1,y1,x2,y2){
	return Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
    },

    loadResource: function(ship, island, resource){
	if(this.isShipOnIsland(ship, island) && ship.cargo.length < this.shipCapacity && _.indexOf(island.items, resource) >= 0){
	  //  console.log("before loading resource %s: "+ship.cargo.join(", "), resource)
	    ship.cargo.push(resource)
	    //console.log("loaded: "+ ship.cargo.join(", "))
	} else {
	    throw "can't load resource, ship not on island or resource not available"
	}
    },

    unloadResource: function(ship, island, resource){
	if(!island.problem){
	    console.log("WARNING: unloadResource called with illegal state, island has no problem")
	} else {
	    //console.log("problem before unload: "+island.problem.join(", "))
	}
	//console.log("cargo before unload: "+ship.cargo.join(", ")+", resource: %s", resource)
	var index = _.indexOf(ship.cargo, resource)
	//console.log("cargo index: %i", index)
	if(index >= 0 && this.isShipOnIsland(ship, island)){
	    ship.cargo.splice(index, 1)
	    if(island.problem){
	       	var problemIndex = _.indexOf(island.problem, resource)
	//	console.log("problem index: %i", problemIndex)
	       if(problemIndex >= 0){
		    island.problem.splice(problemIndex, 1)
		    if(island.problem.length == 1){//problem solved
			var problem = island.problem[0]
			island.problem = null
			this.problemsSolved++
			//respawn problem
	//		console.log("**** spawn new problem")
			var nextIsland = this.placeProblem(problem, false) //TODO delayed reappearance
			
			return {problem: problem, island: nextIsland} //TODO should fire event instead, too lazy atm
		    }
	       }
	   }
	}

	//console.log("problem after unload "+(island.problem ? null : island.problem.join(", ")))
	//console.log("cargo after unlaod: "+ ship.cargo.join(", "))
    },

    setDestination: function(ship, island){
	ship.destination = island
    },

    setDirection: function(ship, direction){
	ship.direction = direction
    },

    moveShips: function(){
	_.each(this.ships, function(ship){
		this.moveShip(ship)
	    }, this)

	this.turn++
    },

    moveShip: function(ship){
	if(ship.destination){
	    
	    var destination = ship.destination
	
	    var dist = this.distance(ship.x, ship.y, destination.x, destination.y)

	    var dx = (destination.x-ship.x)/dist
	    var dy = (destination.y-ship.y)/dist
	    
	    var faktor = ship.speed > Math.abs(dist-destination.width/2) ?  dist-destination.width/2 + 0.5 : ship.speed

	    //XXX quick fix
	    faktor = Math.max(faktor, 1)

	    //if(faktor < ship.speed){
	//	console.log("faktor: "+faktor)
	  //  }

	    ship.x = ship.x+dx*faktor
	    ship.y = ship.y+dy*faktor

	    if(destination.isHidden && this.isShipOnIsland(ship, destination)){
		destination.isHidden = false
	    }
	}
    }
}

exports.IslandsSim = IslandsSim 

exports.Test = function(){

}
