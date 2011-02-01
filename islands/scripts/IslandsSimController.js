function IslandsSimController(){
    this.islandsSim = new IslandsSim(
    	600,//mapWidth,
	400,//mapHeight,
	20,//fogOfWarChunkSize,
	40,//numberOfIslands,
	18,//minIslandSize,
	40,//maxIslandSize,
	12,//numberOfProblemTypes,
	30,//numberOfProblemOccurances,
	2,//resourceTypesPerProblem,
	20,//numberOfShips,
	20,//playersPerWeek,
	false,//isMassStart,
	1//shipCapacity  +
    )

    this.islandsSimView = new IslandsSimView(this, 'worldmap')
    this.islandsSimView.draw(this.islandsSim)
}

function initIslandsSim() {
    new IslandsSimController()
}
