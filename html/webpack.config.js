module.exports = {
   context: __dirname+'/js',
   entry: './src/index.js',
   output: {
       path: __dirname+'/js',
       publicPath: '/js/',
       filename: "index.js"
   },
   module: {
       loaders: [
           { test: /\.js$/, exclude: /node_modules/, loader: "babel-loader" },
           { test: /\.css$/, loader: "style-loader!css-loader" },
           { test: /\.html$/, loader: "html-loader"}
       ]
   }
};
