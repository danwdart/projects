let even = (n) => 0 == n % 2,
    iterate = (n) => even(n)?n/2:3*n+1,
    iterations = (n, m = 0) => (1 == n)?m:iterations(iterate(n), m)+1;
for (let i = 1; i < 10000; i++)
   console.log(i+','+iterations(i));
