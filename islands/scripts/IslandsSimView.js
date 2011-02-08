function IslandsSimView(islandsSimController, canvasId){
    this.islandsSimController = islandsSimController
    console.log("canvasid: "+canvasId)
    this.canvas = document.getElementById(canvasId)
    this.ctx = this.canvas.getContext('2d');
    this.width = this.canvas.width
    this.height = this.canvas.height
    
    this.resourceWidth = 5

}

IslandsSimView.prototype = {
    registerButtons: function(){
	var toggle = this.islandsSimController.togglePlay

	$('#playButton').click(function(event){
		toggle()
			    });
	var reset = this.islandsSimController.reset


	$('#resetButton').click(function(event){
		reset()
			    });



    },
    
    draw: function(islandsSim) {
	if(!this.background) {
	    this.background = this.drawBackgroundImage(islandsSim)
	}	    
	var ctx = this.ctx
	ctx.drawImage(this.background, 0, 0)

	this.drawProblems(islandsSim)
	
	this.drawHiddenIslands(islandsSim)

	this.drawShips(islandsSim)
    },

    drawBackgroundImage: function(islandsSim) {
	var canvas = document.createElement('canvas')
	canvas.setAttribute('width',this.width);
	canvas.setAttribute('height',this.height);
	var ctx = canvas.getContext('2d')

	ctx.fillStyle = "rgb(0,0,255)";
	ctx.fillRect(0,0,this.width, this.height)

	ctx.fillStyle = "rgb(0,255,0)"

	var maxResources = islandsSim.maxResources

	_.each(islandsSim.islands, function(island){
		ctx.beginPath()
		ctx.arc(island.x,island.y, island.width/2, 0, 2*Math.PI, true)
		ctx.fill()

		ctx.save()
		ctx.translate(0,this.resourceWidth/2+1)//draw resources below center, problems above
		
		this.drawResources(ctx, maxResources, island.items, island.x, island.y)
		
		ctx.restore()

		//console.log("draw island x: "+island.x+", y: "+island.y+", width: "+island.width)

	    }, this)

	return canvas;
    },

    drawHiddenIslands: function(islandsSim){
	var ctx = this.ctx
	ctx.fillStyle = "#aaaaaa"

	_.each(islandsSim.islands, function(island){
		if(island.isHidden){
		    ctx.beginPath()
		    ctx.arc(island.x,island.y, island.width/2, 0, 2*Math.PI, true)
		    ctx.fill()
		}
	    }, this)

    },

    drawProblems: function(islandsSim){
	var ctx = this.ctx
	var maxResources = islandsSim.maxResources
	_.each(islandsSim.islands, function(island){
		if(island.problem){
		    ctx.save()

		    ctx.translate(0,-(this.resourceWidth/2+1))//draw resources below center, problems above

		    var resources = _.rest(island.problem,1)
		    //console.log("problem resources: "+resources.length)

		    ctx.fillStyle = "#ff0000"

		    var resourcesWidth = resources.length*this.resourceWidth+resources.length+2

		    ctx.fillRect(island.x-resourcesWidth/2+1,island.y-this.resourceWidth/2-1, resourcesWidth, this.resourceWidth+2) 
		    this.drawResources(ctx, maxResources, resources, island.x, island.y)

		    ctx.restore()

		    //console.log("draw island x: "+island.x+", y: "+island.y+", width: "+island.width)
		}
	    }, this)
    },

    drawResources: function(ctx, maxResources, resources, x, y){
	//console.log("drawResources: "+resources.length+", x: "+x+", y: "+y)
	ctx.save()
	ctx.translate((-resources.length*this.resourceWidth+resources.length-1)/2, -this.resourceWidth/2)
	ctx.strokeStyle = "#ffffff"

	_.each(resources, function(resource, index){
		ctx.translate(index*(this.resourceWidth+1),0)
		ctx.fillStyle = "#"+this.getResourceColor(resource, maxResources).toString(16)
		ctx.fillRect(x,y,this.resourceWidth, this.resourceWidth)
		ctx.strokeRect(x,y,this.resourceWidth, this.resourceWidth)
	    }, this)
	ctx.restore()
    },


    getResourceColor: function(resource, maxResources){
	var value = parseInt(resource, 16)
	var maxValue = parseInt("b"+maxResources, 16)

	color = Math.floor(value*0xffffff/maxValue)
	return color
    },

    drawShips: function(islandsSim){
	var ctx = this.ctx

	ctx.fillStyle = "#ffffff"
	_.each(islandsSim.ships, function(ship){

		if(ship.destination){
		    this.drawDestinationLine(ship)
		}

		//console.log("destination: "+ship.destination)
		//console.log("draw ship "+ship+" x: "+ship.x+", y: "+ship.y)
		ctx.beginPath();
		ctx.moveTo(ship.x+3,ship.y-5);
		ctx.lineTo(ship.x+3,ship.y+5);
		ctx.lineTo(ship.x-5,ship.y+5);
		ctx.fill();

		if(ship.cargo.length > 0){
		    //var resources = ship.cargo//testing
		    this.drawResources(ctx, islandsSim.shipCapacity, ship.cargo, ship.x, ship.y)
		}
	    }, this)

    },

    drawDestinationLine: function(ship){
	var ctx = this.ctx
	//console.log("drawDestLine "+ship.x+", "+ship.y+", "+ship.destination.x+", "+ship.destination.y)
	ctx.strokeStyle = "yellow"
	ctx.lineWidth = 1
	if(ship.type === 'solver'){
	    ctx.strokeStyle = ship.cargo.length > 0 ? "red" : "orange"
	}

	ctx.beginPath()
	ctx.moveTo(ship.x, ship.y)
	ctx.lineTo(ship.destination.x,ship.destination.y)
	ctx.stroke();
    }
}
