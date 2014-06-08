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

    applyMatrix: (rotMatrix) ->
        for point, iter in @points
            # apply matrix transformation
            origMatrix = new Matrix(1, 3, point)
            resMatrix = rotMatrix.mul origMatrix
            @points[iter] = resMatrix.toArray()[0]

class Matrix
    constructor: (w, h, els)->
        {@w, @h, @els} = {w, h, els}

    get: (c,r) -> @els[r * @h + c]

    mul: (m2)->
        if @w != m2.h
            throw new Error 'Cannot multiply this matrix: '+@w + ' by '+m2.h   

        resEls = []

        for lCol in [0..@h-1]
            for rRow in [0..m2.w-1]
                intSum = 0
                for n in [0..@w-1]
                    intSum += @get(lCol, n) * m2.get(n, rRow)
                resEls[lCol * @h + rRow] = intSum

        return new Matrix m2.w, @h, resEls

    toArray: ->
        arr = []
        for x in [0..@w-1]
            arr[x] = []
            for y in [0..@h-1]
                arr[x][y] = @get(x,y)
        return arr


Matrix.createRot = (tx, ty, tz)->
    sx = Math.sin(tx)
    sy = Math.sin(ty)
    sz = Math.sin(tz)

    cx = Math.cos(tx)
    cy = Math.cos(ty)
    cz = Math.cos(tz)

    return new Matrix 3, 3, [
        # yay magic numbers
        cz*cy
        -sz*cy
        sy
        sy*sx*cz + cx*sz
        -sy*sx*sz + cx*cz
        -sx*cy
        -sy*cx*cz + sx*sz
        sy*cx*sz + cz*sx
        cx*cy
    ]
    

cam = new Camera window.innerWidth, window.innerHeight, Math.PI / 2, 0.5, 0.5, -4, 0, 0, 0
map = new Map

rotMatrix = Matrix.createRot 0.01, 0.01, 0.01

frame = ->
    map.applyMatrix rotMatrix
    cam.clear()
    cam.trace(map)
    window.requestAnimationFrame frame
frame()