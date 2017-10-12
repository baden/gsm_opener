const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const workboxPlugin = require('workbox-webpack-plugin');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const path = require('path');

const DIST_DIR = 'dist';

const outputPath = path.resolve(__dirname, DIST_DIR);

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
      new workboxPlugin({
        globDirectory: DIST_DIR,
        globPatterns: ['**/*.{html,js,css,png,woff2,svg}'],
        swDest: path.join(DIST_DIR, 'service-worker.js'),
      }),
      new CopyWebpackPlugin([{
        from: path.join(__dirname, "./src/assets"),
        to: "."
      }]),
      new webpack.NoEmitOnErrorsPlugin(),
      new HtmlWebpackPlugin({
        template: './src/index.html',
        inject: 'body',
        filename: 'index.html'
      }),
    ]
  };
};
