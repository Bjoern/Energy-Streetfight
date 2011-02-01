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
    shipCapacity  
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

    this.maxResources = numberOfProblemTypes*resourceTypesPerProblem

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
		    problem: null
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
	    _.each(_.rest(items), function(resource){this.placeResource(resource)}, this)
	}
    },

    initProblems: function(){
	_.each(_.range(this.numberOfProblemOccurances), function(problem) {
		this.placeProblem(problem, true)

	    }, this);
    },	

    initShips: function(){
	this.ships = _.map(_.range(this.numberOfShips), function(shipIndex){

	    var x = 0, y = 0
	    if(!this.isMassStart) {
		x = Math.abs(Math.random()*this.mapWidth)
		y = Math.abs(Math.random()*this.mapHeight)
	    }
	    return {x: x, y: y, speed: 0, destination: null, direction: null, cargo: []}
	}, this);
    },

    getRandomIsland: function(islands) {
	var island = islands[Math.floor(Math.abs(Math.random()*islands.length))]
	return island
    },

    isShipOnIsland: function(ship, island){
	return this.distance(ship.x, ship.y, island.x, island.y) <= island.width/2
    },

    distance: function(x1,y1,x2,y2){
	return Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
    },

    loadResource: function(ship, island, resource){
	if(this.isShipOnIsland(ship, island) && ship.cargo.length < this.shipCapacity && _.indexOf(island.resources, resource) >= 0){
	    ship.cargo.push(resource)
	}
    },

    unloadResource: function(ship, island, resource){
	var index = _.indexOf(ship.cargo, resource)
	if(index > 0 && this.isShipOnIsland(ship, island)){
	    ship.cargo = ship.cargo.splice(index, 1)
	    if(island.problem){
	       	var problemIndex = _.indexOf(island.problem, resource)
	       if(problemIndex >= 0){
		    island.problem.splice(problemIndex, 1)
		    if(island.problem.length == 1){//problem solved
			var problem = island.problem
			island.problem = null
			//respawn problem
			this.placeProblem(problem, false) //TODO delayed reappearance
		    }
	       }
	   }
	}
    },

    setDestination: function(ship, island){
	ship.destination = island
    },

    setDirection: function(ship, direction){
	
    },

    moveShips: function(){

    }



}
