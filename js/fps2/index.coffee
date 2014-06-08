class Camera
    constructor: (w,h,fov,x,y,z,tx,ty,tz) ->
        @canvases = document.getElementsByTagName 'canvas'
        @canvas = @canvases[0]
        @canvas.height = h
        @canvas.width = w
        @canvas.style.height = h+'px'
        @canvas.style.width = w+'px'
        @ctx = @canvas.getContext '2d'
        {@w,@h,@fov,@x,@y,@z,@tx,@ty,@tz} = {w,h,fov,x,y,z,tx,ty,tz}
        @origin = 
            x: @w/2
            y: @h/2

    clear: ->
        @ctx.fillStyle = 'black'
        @ctx.fillRect 0, 0, @w,@h

    trace: (map) ->
        @ctx.fillStyle = 'white'
        @ctx.strokeStyle = 'white'
        spoints = {}
        for point, iter in map.points
            # Where is it in 2D space?
            dx = point[0] - @x
            dy = point[1] - @y
            dz = point[2] - @z

            tx = Math.atan(dx / dz + @tx)
            ty = Math.atan(dy / dz + @ty)
            tz = @tz

            dpx = @fov * @h * tx
            dpy = @fov * @h * ty

            px = dpx + @origin.x
            py = @origin.y - dpy
            
            spoints[iter] = [px,py]

        for line in map.lines
            @ctx.beginPath()
            @ctx.moveTo spoints[line[0]][0], spoints[line[0]][1]
            @ctx.lineTo spoints[line[1]][0], spoints[line[1]][1]
            @ctx.stroke()

class Map
    constructor: ->
        file = document.getElementById 'map'
        json = file.innerText
        obj = JSON.parse json
        @points = obj.points
        @lines = obj.lines


cam = new Camera window.innerWidth, window.innerHeight, Math.PI / 2, 0.5, 0.3, -4, 0, 0, 0
map = new Map

frame = ->
    cam.clear()
    cam.x += 0.005
    cam.z += 0.005
    cam.tx += 0.0015
    cam.ty = 0.1 * Math.sin cam.tx * 32

    cam.trace(map)
    window.requestAnimationFrame frame
frame()