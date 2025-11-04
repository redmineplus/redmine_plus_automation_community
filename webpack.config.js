const path = require('path');
const mode = process.env.NODE_ENV || 'development';
module.exports = {
  mode,
  entry: {
    redmine_plus_automation_bundle: './frontend/index.tsx',
    issues_dropdown_bundle: './frontend/components/App/Redmine/IssuesAutomationDropdownEntry.tsx'
  },
  output: {
    path: path.resolve(__dirname, 'assets/javascripts'),
    filename: '[name].js',
    publicPath: '/javascripts/',
  },
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        exclude: /node_modules/,
        use: 'babel-loader',
      },
      {
        test: /\.s[ac]ss$/i,
        use: ['style-loader', 'css-loader', 'sass-loader'],
      },
      // css loader
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
  },
  devServer: {
    static: {
      directory: path.resolve(__dirname, 'assets'),
    },
    compress: true,
    port: 8080,
    hot: true,
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
};
