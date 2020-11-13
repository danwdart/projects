console.log(`Hello World!`);
const button = document.querySelector(`button`);
button.addEventListener(`click`, async () => {
    let device;
    try {
        device = await navigator.usb.requestDevice(
            {
                filters: [
                    {
                        //vendorId: 0x0781
                        //classCode: 0x5575
                    }
                ]
            }
        );

        await device.open();
        await device.selectConfiguration(1);
        await device.claimInterface(device.configuration.interfaces[0].interfaceNumber);

        console.log(device);

    } catch (e) {
        console.log(`Oh no`, e);
        // No device was selected.
    }


});
