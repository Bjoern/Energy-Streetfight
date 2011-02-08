function ShipAI(islandsSim){
    this.islandsSim = islandsSim

    this.islandsToDiscover = _.select(this.islandsSim.islands, function(island){return island.isHidden})

    this.problemsToSolve = []

    this.computeShipMovements = function() {

	_.each(islandsSim.ships, function(ship){

		if(!ship.destination || this.islandsSim.isShipOnIsland(ship, ship.destination)) {
		    if('explorer' === ship.type || this.problemsToSolve.length === 0){
			this.computeExplorerMovements(ship)	
		    } else {
			this.computeSolverMovements(ship)
		    }
		}
	    }, this)
    }

    this.addProblems = function(island){
	if(island.problem){
	    this.problemsToSolve.push({island: island, resource: island.problem[1]})
	    this.problemsToSolve.push({island: island, resource: island.problem[2]})
	}
    }

    this.computeExplorerMovements = function(ship){
	//find new destination - this is only being called if ship has no destination or has arrived on destination island

	if(this.islandsSim.isShipOnIsland(ship, ship.destination)){
	    //add problems to solvable problems
	    this.addProblems(ship.destination)    	
	}

	if(this.islandsToDiscover.length >= 0){
	    var minIsland = _.min(this.islandsToDiscover, function(island){
		    return this.islandsSim.distance(ship.x, ship.y, island.x, island.y)
		}, this)
	    ship.destination = minIsland
	    this.islandsToDiscover.splice(_.indexOf(this.islandsToDiscover, minIsland),1)
	} else {
	    ship.type = 'solver'
	    ship.destination = null
	    if(this.problemsToSolve.length > 0) {
		this.computeSolverMovements(ship)
	    }
	}
    }

    this.computeSolverMovements = function(ship){
	//ship has no destination or has arrived on destination
	//assume maxCargo == 1
	
	if(ship.destination && this.islandsSim.isShipOnIsland(ship, ship.destination)){
	    console.log("solver on destination %o", ship)
	    //either load a new resource, or unload to solve problem
	    var destination = ship.destination
	    if(ship.cargo.length > 0){
		//arrived on problem island, unload resource
		console.log("unload resource cargo length: %i"+ship.cargo, ship.cargo.length)
		var solvedProblem = this.islandsSim.unloadResource(ship, ship.destination, ship.cargo[0])
		if(solvedProblem){
		    console.log("problem solved: %o", solvedProblem)
		    this.addProblems(solvedProblem.island)//add to list of problems to solve 
		} else {
		    console.log("problem not solved %o", destination.problem)
		}
		ship.problemToSolve = null
		ship.destination = null
		this.computeSolverMovements(ship)

	    } else if(ship.problemToSolve) {
		//load resource
		this.islandsSim.loadResource(ship, ship.destination, ship.problemToSolve.resource)
		ship.destination = ship.problemToSolve.island //sail to problem island
		console.log("resource loaded %o", ship)
		console.log(ship)
	    } else {
		//must be a solver that was temporarily exploring
		this.computeExplorerMovements(ship)
	    }
	} else {
	    //find new destination
	    //not always optimal, but must do: look for nearest problem, then solve that
	    console.log("solver needs new destination %o", ship)

	    ship.problemToSolve = this.problemsToSolve.length >= 0 ? _.min(this.problemsToSolve, function(problemToSolve) {
		    var island = problemToSolve.island
		    return this.islandsSim.distance(ship.x, ship.y, island.x, island.y) 
		}, this) : null

	    if(ship.problemToSolve) {
		//find nearest island with required resource
		var eligibleIslands = _.select(this.islandsSim.islands, function(island){
			return !island.isHidden && island.items.indexOf(ship.problemToSolve.resource) >= 0
		    }, this)
		ship.destination = eligibleIslands.length >= 0 ? _.min(eligibleIslands, function(island){
			return islandsSim.distance(ship.x, ship.y, island.x, island.y)
		    }, this) : null
	    } else {
		//no open problems, explore
		this.computeExplorerMovements(ship)
	    }
	}	    


    }
}
