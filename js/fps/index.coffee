class Camera
    constructor: (w,h,fov,x,y,z,tx,ty,tz) ->
        @canvases = document.getElementsByTagName 'canvas'
        @canvas = @canvases[0]
        @ctx = @canvas.getContext '2d'
        {@w,@h,@fov,@x,@y,@z,@tx,@ty,@tz} = {w,h,fov,x,y,z,tx,ty,tz}
        @origin = 
            x: @w/2
            y: @h/2

    clear: ->
        @ctx.fillStyle = 'black'
        @ctx.fillRect 0, 0, @w, @h

    trace: (map, res) ->


        for x in [0..@w] by res
            for y in [0..@h] by res
                # first get angle
                tx = @tx + (@fov / @w) * ( x - @origin.x )
                ty = @ty + (@fov / @h) * ( @origin.y - y )

                # get real colour
                @ctx.fillStyle = 'white';
                depth = 1
                while depth < 10
                    dz = Math.floor(depth)
                    dx = Math.floor(depth * Math.sin tx)
                    dy = Math.floor(depth * Math.sin ty)

                    if 0 > @x + dx or map.x < @x + dx or 0 > @y + dy or map.y < @y + dy or 0 > @z + dz or map.z < @z + dz
                        break

                    voxel = map.get(@x + dx, @y + dy, @z + dz)

                    if 0 < voxel.r or 0 < voxel.g or 0 < voxel.b
                        @ctx.fillStyle = 'rgb('+voxel.r+','+voxel.g+','+voxel.b+')'
                        @ctx.fillRect x, y, res, res
                        break

                    depth++
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
        res = @grid[z][y][x]
        return {
            r: res[0]
            g: res[1]
            b: res[2]
        }

    random: ->
        @grid = []
        for x in [0..2]
            @grid[x] = []
            for y in [0..2]
                @grid[x][y] = []
                for z in [0..2]
                    @grid[x][y][z] = []
                    @grid[x][y][z][0] = Math.floor Math.random() * 255
                    @grid[x][y][z][1] = Math.floor Math.random() * 255
                    @grid[x][y][z][2] = Math.floor Math.random() * 255

cam = new Camera window.innerWidth, window.innerHeight, Math.PI / 2, 1, 1, -1, Math.PI / 6, Math.PI / 6, Math.PI / 6
cam.clear()
map = new Map(3,3,3)
map.random()
cam.trace(map, 5)