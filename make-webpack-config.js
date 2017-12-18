const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const workboxPlugin = require('workbox-webpack-plugin');
const CopyWebpackPlugin = require("copy-webpack-plugin");
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const WebpackPwaManifest = require('webpack-pwa-manifest');
const path = require('path');


const DIST_DIR = 'dist';

const outputPath = path.resolve(__dirname, DIST_DIR);

function hasProcessFlag(flag) {
  return process.argv.join('').indexOf(flag) > -1;
}

const HMR = hasProcessFlag('hot');

module.exports = function({ isProd }) {
  console.log("Booooooooo", isProd);


  const plugins = [
    new CopyWebpackPlugin([{
      from: path.join(__dirname, "./src/assets"),
      to: "."
    }]),
    new webpack.NoEmitOnErrorsPlugin(),
    new ExtractTextPlugin("styles.css"),

    new WebpackPwaManifest({
      name: "Progressive GSM-opener",
      short_name: "GSM opener",
      description: "GSM-opener control",
      lang: "en-US",
      display: "fullscreen",
      orientation: "portrait",
      start_url: './',
      background_color: '#eee',
      theme_color: "#eee",
      'theme-color': '#eee',
      icons: [
        {
          src: path.resolve('src/logo.png'),
          sizes: [57, 60, 76, 114, 120, 152, 167, 180, 1024],
          destination: path.join('icons', 'ios'),
          ios: true
        },
        {
          src: path.resolve('src/logo.png'),
          size: 1024,
          destination: path.join('icons', 'ios'),
          ios: 'startup'
        },
        {
          src: path.resolve('src/logo.png'),
          sizes: [36, 48, 72, 96, 144, 192, 512],
          destination: path.join('icons', 'android')
        },
        {
          src: path.resolve('src/logo.png'),
          // sizes: [16, 32, 57, 60, 72, 76, 96, 114, 120, 144, 152, 180, 192, 256, 512],
          sizes: [16, 32, 70, 150, 192, 310],
          destination: path.join('icons', 'other')
        },
      ],
      ios: {
        // 'apple-mobile-web-app-status-bar-style': 'black',
        // 'apple-mobile-web-app-title': 'GSM opener',
        'apple-mobile-web-app-status-bar-style': '#434345',
      },
      fingerprints: false,
    }),

    new HtmlWebpackPlugin({
      template: './src/index.html',
      // inject: 'body',
      inject: true,
      filename: 'index.html',
      minify: { collapseWhitespace: true },
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
        },
        {
          test: /\.elm$/,
          exclude: [/elm-stuff/, /node_modules/],
          use:
            HMR?
              ['elm-hot-loader', {loader: 'elm-webpack-loader', options: {debug: true, warn: true, verbose: true}}]
            :
              ['elm-webpack-loader']
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
