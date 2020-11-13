export function* generator() {
    let i = 0,
        nums = [1,1];
    yield 1;
    yield 1;
    while(true) {
        nums.push(nums[i] + nums[i+1]);
        yield nums[i] + nums[i+1];
        nums.push(nums[i]);
        yield nums[i];
        i++;
    }
}

export function* generatorModded() {
    let i = 0,
        nums = [1,1];
    yield 1;
    yield 1;
    while(true) {
        nums.push(nums[i]);
        yield nums[i];
        nums.push(nums[i] + nums[i+1]);
        yield nums[i] + nums[i+1];
        i++;
    }
}

export function array() {
    var nums = [1,1],
        limit = 1000;
    for (var i = 0; i < limit; i++) {
        nums.push(nums[i] + nums[i+1]);
        nums.push(nums[i+1]);
    }
    return nums;
}