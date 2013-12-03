class Space
	@playing: true
	@bg : 'rgb(0,0,0)'
	@gravG : 1
	@objects : []

class Trace
	@traceLength: 200
	constructor: (object)->
		@el = document.documentElement
		@_d = document.createElement 'div'
		@_d.style.borderRadius = '1px'
		@_d.style.height = '3px'
		@_d.style.width = '3px'
		@_d.style.position = 'absolute'
		@_d.style.backgroundColor = object.colour();
		@_d.style.top = object.coords().y + 20 +'px'
		@_d.style.left = object.coords().x + 20 +'px'
		@el.appendChild @_d
	delete: ->
		@el.removeChild(@_d)

class GravitatingBody
	constructor: () ->
		@_d = {}
		@_posX = 0
		@_posY = 0
		@_m = 0
		@_traces = []
		@_gravX = 0
		@_gravY = 0
		@_velx = 0
		@_vely = 0
		@_restX = 0
		@_restY = 0
		@_diam = 0
		@_col = {
			r:0,
			g:0,
			b:0
		}
	build: () ->
		@_d = document.createElement 'div'
		@_d.style.borderRadius = @_diam/2 + 'px'
		@_d.style.height = @_diam + 'px'
		@_d.style.width = @_diam + 'px'
		@_d.style.position = 'absolute'
		@_d.style.backgroundColor = 'rgb(' + @_col.r + ',' + @_col.g + ',' + @_col.b + ')';
		document.documentElement.appendChild @_d
		@moveTo @_posX, @_posY
	mass: () -> @_m
	moveTo: (x,y) ->
		@_d.style.top = Math.floor(y) + 'px'
		@_d.style.left = Math.floor(x) + 'px'

	coords: -> return {
		x: parseInt @_d.style.left
		y: parseInt @_d.style.top
	}

	colour: -> @_d.style.backgroundColor
	frame: ->
		self = this
		self._gravX = self._gravY = 0
		Space.objects.forEach (object) ->
			return if object == self
			MCtr = object.mass()
			dy = self.coords().y - object.coords().y
			dx = self.coords().x - object.coords().x
			d2 = (Math.pow(dy, 2) + Math.pow(dx, 2))
			d = Math.sqrt d2
			d2xp = dx / d
			d2yp = dy / d
			grav = ( Space.gravG * MCtr ) / d2
			self._gravX += d2xp * grav
			self._gravY += d2yp * grav
		self._vely -= self._gravY
		self._velx -= self._gravX
		newPosX = self.coords().x + self._velx
		newPosY = self.coords().y + self._vely
		self.moveTo newPosX, newPosY
			#@_velx = -@_velx * @_restX if 0 >= this.x() or this.x() >= @el.clientWidth 
			#@_vely = -@_vely * @_restY if 0 >= this.y() or this.y() >= @el.clientHeight
	trace: ->
		if Trace.traceLength <= @_traces.length
			@_traces[0].delete()
			@_traces.shift()
		trace = new Trace this
		@_traces.push(trace)

	setPositionFromEvent : (event) ->
		el = document.documentElement
		if event
			@_posY = event.clientY
			@_posX = event.clientX
		else
			@_posY = Math.floor Math.random()*el.clientHeight
			@_posX = Math.floor Math.random()*el.clientWidth
	

class Planet extends GravitatingBody
	constructor: ()->
		super
		@_m = 3
		@_diam = 40
		@_velx = Math.random() * 6 - 3
		@_vely = Math.random() * 6 - 3
		@_col = {
			r: Math.floor ( Math.random() * 255 )
			g: Math.floor ( Math.random() * 255 )
			b: Math.floor ( Math.random() * 255 )
		}

class Star extends GravitatingBody
	constructor: ()->
		super
		@_m = 10000
		@_posX = 700
		@_posY = 350
		@_diam = 70
		@_col = {
			r:255,
			g:255,
			b:64
		}

	trace: ->
	frame: ->

$(document).ready ->
	$(document.documentElement).css({backgroundColor: Space.bg});
	$(document.documentElement).click (e)->
		if e.button is 0 then b = new Planet
		if e.button is 1 then b = new Star
		b.setPositionFromEvent e
		b.build()
		Space.objects.push b
	$(document.documentElement).keyup (e) ->
		# p
		if e.keyCode is 80
			e.preventDefault()
			Space.playing = !Space.playing
			animate() if Space.playing

	animate = ->
		return if not Space.playing
		Space.objects.forEach (object) ->
			object.trace()
			object.frame()
		window.requestAnimationFrame(animate)
	animate()