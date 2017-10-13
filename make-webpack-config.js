const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const workboxPlugin = require('workbox-webpack-plugin');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const path = require('path');

const DIST_DIR = 'dist';

const outputPath = path.resolve(__dirname, DIST_DIR);

module.exports = function({ isProd }) {
  console.log("Booooooooo", isProd);


  const plugins = [
    new CopyWebpackPlugin([{
      from: path.join(__dirname, "./src/assets"),
      to: "."
    }]),
    new webpack.NoEmitOnErrorsPlugin(),
    new ExtractTextPlugin("styles.css"),
    new HtmlWebpackPlugin({
      template: './src/index.html',
      inject: 'body',
      filename: 'index.html'
    }),

    //  TODO: Look at
    // https://github.com/electrode-samples/electrode-pwa-examples/blob/d5c15d2aff5f835ba088e90202329976ae2e7dd7/examples/product/config/sw-config.js
    // https://github.com/electrode-samples/electrode-pwa-examples/blob/d5c15d2aff5f835ba088e90202329976ae2e7dd7/examples/product/client/sw-registration.js

    new workboxPlugin({
      // cacheId: 'mu',
      // handleFetch: true,
      globDirectory: DIST_DIR,
      globPatterns: ['**/*.{html,js,css,png,woff2,svg}'],
      navigateFallback: '/index.html',
      // navigateFallback: '/offline.html',
      runtimeCaching: [
        {
          urlPattern: /^https:\/\/fonts\.gstatic\.com(.+)/,
          handler: 'cacheFirst'
        },
        {
          urlPattern: /^https:\/\/fonts\.googleapis\.com(.+)/,
          handler: 'cacheFirst'
        }
      ],
      swDest: path.join(DIST_DIR, 'service-worker.js'),
    }),
  ];

  if (isProd) {
    plugins.push(...[
      new webpack.optimize.UglifyJsPlugin({
              compress: {
                warnings: false,
                screw_ie8: true,
                conditionals: true,
                unused: true,
                comparisons: true,
                sequences: true,
                dead_code: true,
                evaluate: true,
                if_return: true,
                join_vars: true,
              },
              output: {
                comments: false
              },
              sourceMap: true,
            })
    ]);
  }


  return {
    entry: {
        app: './src/index.js',
    },
    output: {
      path: outputPath,
      filename: isProd ? 'js/[name]-[hash].js' : 'js/[name].js'
    },
    devtool: isProd ? 'source-map' : 'eval',
    module: {
      rules: [
        {
          test: /\.(scss|sass|css)$/i,
          use: ['css-hot-loader'].concat(ExtractTextPlugin.extract({
            fallback: 'style-loader',
            use: ['css-loader', 'sass-loader']
          })),
        },
        { test: /\.(jpe?g|png|gif|svg|eot|woff|ttf|svg|woff2)$/,
          use: [
            {
              loader: 'url-loader',
              options: {
                limit: 10000,
                name: 'font/[name].[hash].[ext]'
              }
            }
          ]
          // loader: "file?name=[name].[ext]"
          // loader: 'url-loader?mimetype=applicationfont-woff2&name=fonts/[name].[ext]'
        }
      ]
    },
    plugins,
    devServer: {
      contentBase: './src/',
      // inline: true,
      // hot: true,
      // inline: !isProd,
      // hot: !isProd,
      historyApiFallback: true,
      open: true
    }
  };
};
