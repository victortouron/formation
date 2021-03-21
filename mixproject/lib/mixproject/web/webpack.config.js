module.exports = {
  entry: './my-babel-plugin/script.js',
  output: { filename: 'bundle.js' },
  plugins: [],
  module: {
    loaders: [
      {
        test: /.js?$/,
        loader: 'babel-loader',
        exclude: /node_modules/,
        query: {
          presets: ['es2015', 'react',
          [
            'jsxz',
            {
              dir: 'webflow'
            }
          ]
        ],
        plugins: ['./my-babel-plugin']
        }
      }
    ]
  },
}
