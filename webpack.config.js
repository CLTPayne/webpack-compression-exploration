const CompressionPlugin = require("compression-webpack-plugin");

module.exports = {
  entry: {
    "dist/main": "./src/index.js"
  },
  output: {
    path: __dirname
  },
  module: {
    rules: [
      {
        test: /\.m?js$/,
        exclude: /(node_modules)/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"]
          }
        }
      }
    ]
  },
  plugins: [
    new CompressionPlugin({
      test: /\.(js|css)$/,
      algorithm: "gzip",
      compressionOptions: { level: 9 }
    })
  ]
};
