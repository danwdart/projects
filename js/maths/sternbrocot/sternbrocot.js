var nums = [1,1],
    limit = 1000;
for (var i = 0; i < limit; i++) {
    nums.push(nums[i] + nums[i+1]);
    console.log(nums[i] + nums[i+1]);
    nums.push(nums[i+1]);
    console.log(nums[i+1]);
}
    
