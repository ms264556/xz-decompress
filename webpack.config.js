const path = require('path');
const webpack = require('webpack');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  mode: 'production',
  entry: './src/xz-decompress.js',
  devtool: false,
  output: {
    filename: 'xz-decompress.esm.js',
    path: path.resolve(__dirname, 'dist/package'),
    library: {
      type: 'module'
    },
    module: true
  },
  experiments: {
    outputModule: true
  },
  module: {
    rules: [
      {
        test: /\.wasm$/,
        type: 'asset/inline'
      }
    ]
  },
  optimization: {
    minimize: true,
    minimizer: [
      new TerserPlugin({
        extractComments: false
      })
    ]
  },
  plugins: [
    new webpack.BannerPlugin({
      banner: [
        'Based on xzwasm (c) Steve Sanderson. License: MIT - https://github.com/SteveSanderson/xzwasm',
        'Contains xz-embedded by Lasse Collin and Igor Pavlov. License: Public domain - https://tukaani.org/xz/embedded.html',
        'and walloc (c) 2020 Igalia, S.L. License: MIT - https://github.com/wingo/walloc'
      ].join('\n')
    })
  ]
}
