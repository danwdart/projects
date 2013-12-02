gravG = 0.1
gravXCtr = 800
gravYCtr = 500
MCtr = 1000
frcX = 0
frcY = 0

Math.sgn = (val) ->
	if val > 0
		return 1
	if val < 0
		return -1
	return 0

class Ball
	constructor: (event)->
		@el = document.documentElement
		if event
			posY = event.clientY
			posX = event.clientX
		else
			posY = Math.floor Math.random()*@el.clientHeight
			posX = Math.floor Math.random()*@el.clientWidth
		@m = 1
		@gravX = 0
		@gravY = 0
		@_velx = 0
		@_vely = 0
		@_restX = 0
		@_restY = 0
		@d = document.createElement 'div'
		@d.style.borderRadius = '20px'
		@d.style.height = '40px'
		@d.style.width = '40px'
		@d.style.position = 'absolute'
		r = parseInt Math.random()*255
		g = parseInt Math.random()*255
		b = parseInt Math.random()*255
		@d.style.backgroundColor = 'rgb(' + r + ',' + g + ',' + b + ')';
		@d.style.top = posY - 20 + 'px'
		@d.style.left = posX - 20 + 'px'
		document.documentElement.appendChild @d
	velocityX: -> @_velx
	velocityY: -> @_vely
	frame: ->
		dsy 
		@gravX = gravG * MCtr * @m /( ^ 2)
		@gravY = gravG * MCtr * @m /(( @y() - gravYCtr ) ^ 2)
		@_vely -= @gravY
		@_velx -= @gravX
		this.setX(Math.floor this.x()+@_velx)
		this.setY(Math.floor this.y()+@_vely)
		@_velx = -@_velx * @_restX if 0 >= this.x() or this.x() >= @el.clientWidth 
		@_vely = -@_vely * @_restY if 0 >= this.y() or this.y() >= @el.clientHeight
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