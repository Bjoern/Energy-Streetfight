function IslandsSimController(){
    this.islandsSim = new IslandsSim(
    	600,//mapWidth,
	400,//mapHeight,
	20,//fogOfWarChunkSize,
	40,//numberOfIslands,
	18,//minIslandSize,
	40,//maxIslandSize,
	12,//numberOfProblemTypes,
	3,//numberOfProblemOccurances,
	2,//resourceTypesPerProblem,
	20,//numberOfShips,
	20,//playersPerWeek,
	false,//isMassStart,
	1//shipCapacity  +
    )

        this.shipAI = new ShipAI(this.islandsSim)

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

    this.reset = function(){
	this.pause()
    }

    _.bindAll(this, "togglePlay", "play", "pause", "reset", 'run')

    this.run = function(){
	//console.log("run turn "+this.islandsSim.turn)
	this.shipAI.computeShipMovements()
	this.islandsSim.moveShips()
	this.islandsSimView.draw(this.islandsSim)

	if(this.isRunning){
	    _.defer(_.bind(this.run, this))
	}
    }

    this.islandsSimView = new IslandsSimView(this, 'worldmap')
    this.islandsSimView.draw(this.islandsSim)
    this.islandsSimView.registerButtons()

}

$(window).load(function(){
    new IslandsSimController()
})
