const instructions = [
    {
        type: "insert",
        data: {
            "location": "start",
            "html": [
                {
                    "tag": "h1",
                    "inside": "Hi"
                }
            ]
        }
    }
];

const instructionMap = ({window, document}) => {
    insert: data => {

    }
};