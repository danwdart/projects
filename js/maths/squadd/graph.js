let T = 2 * Math.PI,
    canvas = document.querySelector('canvas'),
    h = window.innerHeight,
    w = window.innerWidth;
canvas.height = h;
canvas.width = w;
canvas.style.height = h+'px';
canvas.style.width = w + 'px';
let ctx = canvas.getContext('2d'),
    drawNumberInCircle = (x, y, i) => {
        ctx.beginPath();
        ctx.arc(x, y, 20, 0, T);
        ctx.stroke();

        ctx.font = '12px Sans';
        ctx.fillText(i, x - 6, y + 6);
    },
    drawNumbersInCircles = (numbers) => {
        for (let i in numbers) {
            let number = numbers[i];
            drawNumberInCircle(number.x, number.y, i);
        }
    },
    drawLinesBetweenNumbers = (numbers) => {
        for (let i in numbers) {
            let number = numbers[i];
            for (let link of number.links) {
                ctx.moveTo(number.x, number.y);
                ctx.lineTo(numbers[link].x, numbers[link].y);
                ctx.stroke();
            }
        }
    },
    clear = () => ctx.clearRect(0, 0, w, h),
    setupNumbers = (num) => {
        let numbers = {};
        for (let i = 1; i <= num; i++) {
            let x = 40 * i % w,
                y = 40;

            numbers[i] = {
                x,
                y,
                links: new Set()
            };
        }

        return numbers;
    },
    squadd = (n, b = 10) => {
        let total = 0,
            ns = n.toString(b);
        for (let i = 0; i < ns.length; i++) {
            total += Math.pow(Number(ns.charAt(i)), 2);
        }
        return total;
    },
    linkNumbers = (numbers) => {
        for (let i in numbers) {
            let number = numbers[i],
                squadded = squadd(i);
            if ('undefined' == typeof numbers[squadded]) {
                numbers[squadded] = {
                    x: number.x,
                    y: number.y + 40,
                    links: new Set()
                };
            }
            else {
                numbers[squadded].x = number.x;
                numbers[squadded].y = number.y + 40;
            }

            numbers[i].links.add(squadd(i));
        }

        numbers[2].links.add(3);
        return numbers;
    },
    dist = (x1, x2, y1, y2) => {
        return Math.sqrt(
            Math.pow(y2 - y1, 2) +
            Math.pow(x2 - x1, 2)
        )
    }
    gravitate = (x1, y1, x2, y2) => {
        let close = dist(x1, x2, y1, y2) < 50;
        return [
            close ? x1: x1 + (x2 - x1) * 0.01,
            close ? y1: y1 + (y2 - y1) * 0.01
        ];
    },
    antigravity = (x, y, it, numbers) => {
        for (let i in numbers) {
            let number = numbers[i];
            if (x == number.x && y == number.y) continue;
            let prox = dist(x, y, number.x, number.y);
            if (40 > prox) {
                x -= (number.x - x) * 0.01;
                y -= (number.y - y) * 0.01;
            }
        }
        return [x,y];
    },
    frigWithNumbers = (numbers) => {
        for (let i in numbers) {
            let number = numbers[i];
            for (let link of number.links) {
                [number.x, number.y] = gravitate(
                    number.x, number.y,
                    numbers[link].x, numbers[link].y
                );
            }
            [number.x, number.y] = antigravity(
                number.x, number.y,
                i, numbers
            );
            numbers[i] = number;
        }
        return numbers;
    };

let numbers = setupNumbers(50);
numbers = linkNumbers(numbers);

let frame = () => {
        clear();
        frigWithNumbers(numbers);
        drawNumbersInCircles(numbers);
        drawLinesBetweenNumbers(numbers);
        requestAnimationFrame(frame);
    };
requestAnimationFrame(frame);

//for (let number in numbers) {
//    let coords = numbers[number];
//}
