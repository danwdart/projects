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

    applyMatrix: (transMatrix) ->
        for point, iter in @points
            # apply matrix transformation
            origMatrix = new Matrix(1, 3, point)
            resMatrix = transMatrix.mul origMatrix
            @points[iter] = resMatrix.toArray()[0]

    apply4DMatrix: (transMatrix) ->
        for point, iter in @points
            # apply matrix transformation
            origMatrix = new Matrix(1, 4, [point[0],point[1],point[2],1])
            resMatrix = transMatrix.mul origMatrix
            arrOut = resMatrix.toArray()[0]
            @points[iter] = [arrOut[0],arrOut[1],arrOut[2]]

class Matrix
    constructor: (w, h, els)->
        {@w, @h, @els} = {w, h, els}

    get: (c,r) -> @els[r * @w + c]

    mul: (m2)->
        if @w != m2.h
            throw new Error 'Cannot multiply this matrix: '+@w + ' by '+m2.h   

        resEls = []

        for lRow in [0..@h-1]
            for rCol in [0..m2.w-1]
                intSum = 0
                for n in [0..@w-1]
                    intSum += ( @get(n, lRow) * m2.get(rCol, n) )
                resEls[rCol * m2.w + lRow] = intSum

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

Matrix.createTrans = (dx, dy, dz)->

    return new Matrix 4, 4, [
        1,0,0,dx
        0,1,0,dy
        0,0,1,dz
        0,0,0,1
    ]
    

cam = new Camera window.innerWidth, window.innerHeight, Math.PI / 2, 5, 0.5, -7, 0, 0, 0
map = new Map

frame = ->
    cam.clear()
    cam.trace(map)
    window.requestAnimationFrame frame
frame()

window.addEventListener 'keydown', (e) ->
    switch e.keyCode
        when 87, 38 #fwd
            transMatrix = Matrix.createTrans 0, 0, -0.2
            map.apply4DMatrix(transMatrix)
        when 83, 40 #back
            transMatrix = Matrix.createTrans 0, 0, 0.2
            map.apply4DMatrix(transMatrix)
        when 65 #strafe left
            transMatrix = Matrix.createTrans 0.2, 0, 0
            map.apply4DMatrix(transMatrix)
        when 68 #strafe right
            transMatrix = Matrix.createTrans -0.2, 0, 0
            map.apply4DMatrix(transMatrix)
        when 37 #rotLeft
            rotMatrix = Matrix.createRot 0,0.2,0
            map.applyMatrix(rotMatrix)
        when 39 #rotRight
            rotMatrix = Matrix.createRot 0,-0.2,0
            map.applyMatrix(rotMatrix)
