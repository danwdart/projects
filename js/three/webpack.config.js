module.exports = {
    context: __dirname+'/js',
    devtool: 'inline-source-map',
    entry: './src/index.ts',
    output: {
        path: __dirname+'/js',
        publicPath: '/js/',
        filename: "index.js"
    },
    resolve: {
        extensions: [
            '.tsx',
            '.ts',
            '.js'
        ]
    },
    module: {
        rules: [
            {
                test: /\.css$/,
                use: [
                    {
                        loader: "style-loader"
                    },
                    {
                        loader: "css-loader"
                    }
                ]
            },
            { test: /\.js$/, exclude: /node_modules/, use: "babel-loader" },
            { test: /\.ts$/, exclude: /node_modules/, use: "ts-loader" },
        ]
    }
};
