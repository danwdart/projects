gravG = 1
gravXCtr = 800
gravYCtr = 500
MCtr = 10000
frcX = 0
frcY = 0
traceLength = 200

Math.sgn = (val) ->
	if val > 0
		return 1
	if val < 0
		return -1
	return 0

class Trace
	constructor: (ball)->
		@el = document.documentElement
		@d = document.createElement 'div'
		@d.style.borderRadius = '1px'
		@d.style.height = '3px'
		@d.style.width = '3px'
		@d.style.position = 'absolute'
		r = 0
		g = 0
		b = 0
		@d.style.backgroundColor = ball.colour();
		@d.style.top = ball.y() + 20 +'px'
		@d.style.left = ball.x() + 20 +'px'
		@el.appendChild @d
	delete: ->
		@el.removeChild(@d)

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
		@traces = []
		@gravX = 0
		@gravY = 0
		@_velx = Math.random() * 6 - 3
		@_vely = Math.random() * 6 - 3
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
	colour: -> @d.style.backgroundColor
	velocityX: -> @_velx
	velocityY: -> @_vely
	frame: ->
		dy = @y() - gravXCtr 
		dx = @x() - gravXCtr 
		d2 = (Math.pow(dy, 2) + Math.pow(dx, 2))
		d = Math.sqrt d2 
		d2xp = dx / d
		d2yp = dy / d
		@gravX = d2xp * gravG * MCtr * @m / d2
		@gravY = d2yp * gravG * MCtr * @m / d2
		@_vely -= @gravY
		@_velx -= @gravX
		this.setX(Math.floor this.x()+@_velx)
		this.setY(Math.floor this.y()+@_vely)
		#@_velx = -@_velx * @_restX if 0 >= this.x() or this.x() >= @el.clientWidth 
		#@_vely = -@_vely * @_restY if 0 >= this.y() or this.y() >= @el.clientHeight
	trace: ->
		if traceLength <= @traces.length
			@traces[0].delete()
			@traces.shift()
		trace = new Trace this
		@traces.push(trace)
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
			ball.trace()
			ball.frame()
		window.requestAnimationFrame(animate)
	animate()