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

    initProblems: function(){
	_.each(_.range(this.numberOfProblemOccurances), function(problem) {
		var items = [problem, "a"+problem]
	        if (this.resourceTypesPerProblem == 2) {
		    items.push("b"+problem)
		}

		_.each(items, function(item) {
		    
			var destinationIsland = null

			var attempts = 0 //primitive way to avoid futile distribution attempts
			while(!destinationIsland){	
			    var island = this.getRandomIsland()
			    if(typeof item == 'string' && !island.problem){
				island.problem = items
				destinationIsland = island
			    } else if(island.items.length < 2 && !_.any(island.items, function(islandItem) {islandItem === item})){
				   island.items.push(item)
				    destinationIsland = island
			    }
			    attempts++;
			    if(attempts > 200) {
				throw {msg: "Unable to place item "+item+" after 200 retries"}
			    }
			}

		    }, this)
		
	    }, this);
    },	

    initShips: function(){
	this.ships = _.map(_.range(this.numberOfShips), function(shipIndex){

	    var x = 0, y = 0
	    if(!this.isMassStart) {
		x = Math.abs(Math.random()*this.mapWidth)
		y = Math.abs(Math.random()*this.mapHeight)
	    }
	    return {x: x, y: y, dx: 0, dy: 0, destination: null, cargo: null}
	}, this);
    },

    getRandomIsland: function() {
	var island = this.islands[Math.floor(Math.abs(Math.random()*this.islands.length))]
	return island
    }


}
