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
      filename: "[path].gz[query]",
      test: /\.(js|css)$/,
      algorithm: "gzip",
      compressionOptions: { level: 9 }
    }),
    new CompressionPlugin({
      filename: "[path].br[query]",
      test: /\.(js|css)$/,
      algorithm: "brotliCompress",
      compressionOptions: { level: 11 }
    })
  ]
};
