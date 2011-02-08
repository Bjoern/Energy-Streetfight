function IslandsSimController(){
    this.isRunning = false

    this.togglePlay = function(){
	console.log("toggle")
	if(this.isRunning){
	    this.pause()
	} else {
	    this.play()
	}

    }

    this.play = function(){
	this.isRunning = true
	this.run()
    }

    this.pause = function(){
	this.isRunning = false
    }

    this.restart = function(mapWidth, mapHeight, numberOfIslands, minIslandSize, maxIslandSize, numberOfProblemTypes,
	    numberOfProblemOccurances, resourceTypesPerProblem, numberOfShips, playersPerWeek, isMassStart, shipCapacity, fractionOfExplorers){
	    this.pause()

	    this.islandsSim = new IslandsSim(
		mapWidth,
		mapHeight,
		20,//fogOfWarChunkSize,
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
	    )
	    this.shipAI = new ShipAI(this.islandsSim)
	    if(!this.islandsSimView){
		this.islandsSimView = new IslandsSimView(this, 'worldmap')
		this.islandsSimView.registerButtons()
	    }

	    this.islandsSimView.setMapDimensions(mapWidth, mapHeight)
	    this.islandsSimView.draw(this.islandsSim)
	}

    _.bindAll(this, "togglePlay", "play", "pause", "restart", "run", "doStep")

    this.doStep = function(){
	this.shipAI.computeShipMovements()
	this.islandsSim.moveShips()
	this.islandsSimView.draw(this.islandsSim)
    }

    this.run = function(){
	//console.log("run turn "+this.islandsSim.turn)
	this.doStep()

	if(this.isRunning){
	    _.defer(_.bind(this.run, this))
	}
    }
 
    this.restart(
    	600,//mapWidth,
	400,//mapHeight,
	//20,//fogOfWarChunkSize,
	40,//numberOfIslands,
	18,//minIslandSize,
	40,//maxIslandSize,
	12,//numberOfProblemTypes,
	1,//numberOfProblemOccurances,
	2,//resourceTypesPerProblem,
	10,//numberOfShips,
	20,//playersPerWeek,
	false,//isMassStart,
	1,//shipCapacity,
	0.3//fractionOfExplorers
    )

}

$(window).load(function(){
    new IslandsSimController()
})
