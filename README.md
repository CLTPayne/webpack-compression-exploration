# Webpack Compression Exploration

An isolated environment to explore how webpack configuration works for compressing assets with various algorithms and how these plugins work with other webpack setup and plugins.

### Quickstart:

#### How to start a project:

1. Fork this project in the GitHub UI
2. Clone your forked copy `git clone https://github.com/[YOUR-USERNAME]/webpack-compression-exploration`
3. Change into the directory `cd webpack-compression-exploration`
4. Use node version 10.8.0 and have npm installed
5. Run `npm install` to add module dependencies

#### How to run the code:

1. Build the bundle in one terminal window with `npm run build`
2. Open the server in a second terminal window with `npm start`
3. Your default browser will open the application at localhost:8080
4. When finished with the application, close both process with `^c`

#### Project Goals:

1. Understand how to set up a project correctly for webpack to compress bundle assets
2. Know how webpack plugins work and where in the webpack process they hook in
3. Explore how a range of plugins play together
4. Look at how compression assists with web performance (and the trade offs involved) and caching strategies.

#### User Stories:

```
As a developer
So that I can implement asset compression and caching strategies
I need an isolated project to build a test case
```

#### Investigation:

##### Iteration 1

1. Cloned a small dummy React project with very basic webpack config in place.
2. Explored suggestions for compression from [Google](https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching) with an aim to enabling long term caching.
3. Implement gzip compression algorithm. Results:

- dist/main.js 123 KiB
- dist/main.js.gz 39.1 KiB
- 214% decrease in over all `.js` file size follinging gzip for Javascript.

##### Iteration 2

1. Alternative compression algorithmWhy Brotli? Based on stats listed by [Google](). It is:

- 14% smaller than gzip for JavaScript
- 21% smaller than gzip for HTML
- 17% smaller than gzip for CSS

##### Conclusions

##### Questions

#### References:

- https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching
- https://web.dev/codelab-text-compression-brotli
- https://web.dev/codelab-text-compression
