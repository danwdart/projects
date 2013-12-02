gravX = 0
gravY = 0.1
frcX = 0
frcY = 4

class Ball
	constructor: (event)->
		@el = document.documentElement
		@_velx = 0
		@_vely = 0
		@_restX = 0
		@_restY = 0.7
		@d = document.createElement 'div'
		@d.style.borderRadius = '20px'
		@d.style.height = '40px'
		@d.style.width = '40px'
		@d.style.position = 'absolute'
		r = parseInt Math.random()*255
		g = parseInt Math.random()*255
		b = parseInt Math.random()*255
		@d.style.backgroundColor = 'rgb(' + r + ',' + g + ',' + b + ')';
		@d.style.top = event.clientY - 20 + 'px'
		@d.style.left = event.clientX - 20 + 'px'
		document.documentElement.appendChild @d
	velocityX: -> @_velx
	velocityY: -> @_vely
	frame: ->
		@_vely += gravY
		this.setX(Math.floor this.x() + @_velx)
		this.setY(Math.floor this.y() + @_vely)
		@_velx = -@_velx * @_restX if this.x() >= @el.clientWidth
		@_vely = -@_vely * @_restY if this.y() >= @el.clientHeight
	x: -> parseInt @d.style.left
	y: -> parseInt @d.style.top
	setX: (x)->
		@d.style.left = x + 'px'
	setY: (y)->
		@d.style.top = y + 'px'

$(document).ready ->
	balls = []

	$(document.documentElement).click (e)->
		b = new Ball e
		balls.push b
	animate = ->
		balls.forEach (ball) ->
			ball.frame()
		window.requestAnimationFrame(animate)
	animate()