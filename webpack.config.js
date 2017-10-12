const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const path = require('path');

const outputPath = path.resolve(__dirname, 'dist');

module.exports = function(options) {
  return {
    entry: {
        app: './src/index.js',
    },
    output: {
      path: outputPath,
      filename: 'js/[name]-[hash].js'
    },
    plugins: [
      new webpack.NoEmitOnErrorsPlugin(),
      new HtmlWebpackPlugin({
        template: './src/index.html',
        inject: 'body',
        filename: 'index.html'
      })
    ]
  };
};
