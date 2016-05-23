function* sternbrocot() {
    var i = 0;
        nums = [1,1];
    yield 1;
    yield 1;
    while(true) {
        nums.push(nums[i] + nums[i+1]);
        yield nums[i] + nums[i+1];
        nums.push(nums[i+1]);
        yield nums[i+1];
        i++;
    }
}

var sb = sternbrocot();

for (;;) {
    console.log(sb.next);
}
