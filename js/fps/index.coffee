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

    trace: (map, res, maxdepth) ->
        for y in [0..@h] by res
            for x in [0..@w] by res
                # first get angle
                tx = @tx + (@fov / @w) * ( x - @origin.x )
                ty = @ty + (@fov / @h) * ( @origin.y - y )

                # get real colour
                depth = 1
                while depth < maxdepth
                    dz = Math.floor(depth)
                    dx = Math.floor(depth * Math.sin tx)
                    dy = Math.floor(depth * Math.sin ty)

                    newx = @x + dx
                    newy = @y + dy
                    newz = @z + dz
                    
                    if 0 > newx or map.x <= newx or 0 > newy or map.y <= newy or 0 > newz or map.z <= newz
                        depth++
                        continue

                    voxel = map.get(newx, newy, newz)

                    if 0 == voxel.r and 0 == voxel.g and 0 == voxel.b
                        depth++
                        continue

                    style = 'rgb('+voxel.r+','+voxel.g+','+voxel.b+')'
                    @ctx.fillStyle = style
                    @ctx.fillRect x, y, res, res
                    break
class Map
    constructor: (x,y,z) ->
        @grid = []
        {@x,@y,@z} = {x,y,z}

    get: (x,y,z) ->
        if (x < 0 or x >= @x or y < 0 or y >= @y or z < 0 or z >= @z)
            return {
                r: 0
                g: 0
                b: 0
            }

        x = Math.floor x
        y = Math.floor y
        z = Math.floor z

        res = @grid[x][y][z]
        return {
            r: res[0]
            g: res[1]
            b: res[2]
        }

    random: ->
        @grid = []
        for x in [0..@x-1]
            @grid[x] = []
            for y in [0..@y-1]
                @grid[x][y] = []
                for z in [0..@z-1]
                    @grid[x][y][z] = [
                        Math.floor Math.random() * 255
                        Math.floor Math.random() * 255
                        Math.floor Math.random() * 255
                    ]

cam = new Camera window.innerWidth, window.innerHeight, Math.PI / 2, -10, 5, -10, 0, 0, 0
cam.clear()
map = new Map 10, 10, 10
map.random()

frame = ->
    cam.clear()
    cam.tx += 0.05
    cam.trace(map, 10, 15)
    window.requestAnimationFrame frame

frame()