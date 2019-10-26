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
3. Implement gzip compression algorithm via `compression-webpack-plugin`. Results:

-   dist/main.js 123 KiB
-   dist/main.js.gz 39.1 KiB
-   214% decrease in over all `.js` file size follinging gzip for Javascript.

##### Iteration 2

1. Alternative compression algorithmWhy Brotli? Based on stats listed by [Google](). It is:

-   14% smaller than gzip for JavaScript
-   21% smaller than gzip for HTML
-   17% smaller than gzip for CSS

2. Implement brotli compression via `brotli-webpack-plugin`. Results:

-   dist/main.js 123 KiB
-   dist/main.js.br 34.3 KiB
-   dist/main.js.gz 39.1 KiB

Difference between the brotli emmitted file and the gzip is not dramatic. But it is 13.99% smaller than the gzip compressed version of the same asset as the webpack gzip plugin emitted.

##### Iteration 3

1. Bump node verion to >=11.7.0
2. Use native support for brotli by implementing instance of `compression-webpack-plugin` with brotli compression algorithm. Results:

-   dist/main.js 123 KiB
-   dist/main.js.br 34.3 KiB
-   dist/main.js.gz 39.1 KiB

_NOTE:_ You need to include the `filename` property in the `compression-webpack-plugin` options object when using `algorithm: 'brotliCompress'`. This isn't needed for `gzip` but without it the `.br` file is not emitted.

##### Conclusions

1. File size of the compressed output is the same when using the separate brotli plugin vs native support for brotli. If using node >=11.7.0 the latter is preferable as it's is one less development dependency to support.
2. With "on the fly" compression at the server or CDN level you need to carefully consider which compression algorithm and how high to set the compression level for each asset type because high compression rates (especially with Brotli) takes time and results in latency. The end user thus waits longer for the assets to be delivered to the browser. This is still an issue for dynamically generated content (e.g. news stories)
3. Static compression of assets at build lengthens the overall build time but removes the above debate. For static content this seems like a natural choice.
4. When you handle the compression your self (rather than a server libarary or CDN configuration performing "on the fly" compression) you need to be sure to correctly set the `Content-Encoding` and `Content-Type` headers for the receiving client to correctly process the file.
    ```
    "When present, the Content-Encoding value indicates which encodings were applied to the entity-body.
    It lets the client know how to decode in order to obtain the media-type referenced by the
    Content-Type header."
    ```

##### Questions

1. What metadata is attached to the compressed assets? To send a file to the browswer it needs to know what the `Content-Type` property is. To try to answer this and mirror the deploy system at work I manually added these emitted `/dist` files to an S3 bucket and reviewed the metadata:

-   `main.js` => `Content-Type: application/javascript`
-   `main.js.gz` => `Content-Type: application/x-gzip`
-   `main.js.br` => `Content-Type: binary/octet-stream`

2. How do you programatically change the `.gz` and `.br` files to have `Content-Type: application/javascript`? Is this needed? [Yes](https://stackoverflow.com/questions/23600229/what-content-type-header-to-use-when-serving-gzipped-files).

#### Post Compression / Usecase:

To serve the statically compressed assets, they need to be uploaded to an AWS S3 bucket and have the `Content-Type` property correctly set to represent the decompressed state of the file. Considerations:

-   Would you want the upload process to run in all environments?
-   AWS provide an SDK as well as a CLI.
-   Should this be a Bash script or a JavaScript process? What are the pros and cons of each? Intention is for it to run in Circle Ci.
-   What is the correct `Content-Type` for a source map? [Seems to not matter for the dev tools](https://stackoverflow.com/questions/19911929/what-mime-type-should-i-use-for-javascript-source-map-files)
-   Is a default of `Content-Type: application/octet-stream` safe? Are there edge cases that this causes problems for.
-   Do you need to handle the `Content-Type` and `Content-Encoding` properties seperately (e.g the former at upload and the latter at the CDN when sending the response to the client)? An AWS S3 object can hold both properties: ![AWS S3 Object Properties](./readme_images/AWS_S3_Object_MetaData_Header_Options.png)

#### References:

-   https://developers.google.com/web/fundamentals/performance/webpack/use-long-term-caching
-   https://web.dev/codelab-text-compression-brotli
-   https://web.dev/codelab-text-compression
-   https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Encoding
-   https://devhints.io/bash

#### Other performance things you can do with webpack:

-   https://github.com/iamakulov/awesome-webpack-perf
