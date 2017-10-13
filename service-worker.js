importScripts('workbox-sw.prod.v2.1.0.js');

/**
 * DO NOT EDIT THE FILE MANIFEST ENTRY
 *
 * The method precache() does the following:
 * 1. Cache URLs in the manifest to a local cache.
 * 2. When a network request is made for any of these URLs the response
 *    will ALWAYS comes from the cache, NEVER the network.
 * 3. When the service worker changes ONLY assets with a revision change are
 *    updated, old cache entries are left as is.
 *
 * By changing the file manifest manually, your users may end up not receiving
 * new versions of files because the revision hasn't changed.
 *
 * Please use workbox-build or some other tool / approach to generate the file
 * manifest which accounts for changes to local files and update the revision
 * accordingly.
 */
const fileManifest = [
  {
    "url": "icons/android/icon_144x144.png",
    "revision": "d3ec54bc62e1fbf58d594e7d4892092b"
  },
  {
    "url": "icons/android/icon_192x192.png",
    "revision": "b2e3fd1114f011e1b9209dffe9c611b2"
  },
  {
    "url": "icons/android/icon_36x36.png",
    "revision": "4c7e4a050297dec4057b770a89965bd9"
  },
  {
    "url": "icons/android/icon_48x48.png",
    "revision": "13d84bbac334d40b118b10adf2f50fb9"
  },
  {
    "url": "icons/android/icon_512x512.png",
    "revision": "7bc6fba1839f37c6069b2e81e869122e"
  },
  {
    "url": "icons/android/icon_72x72.png",
    "revision": "5c77da6695e7a73223e0c5c830d63ea5"
  },
  {
    "url": "icons/android/icon_96x96.png",
    "revision": "4404775c10e57bc56ca6416422c686d0"
  },
  {
    "url": "icons/ios/icon_1024x1024.png",
    "revision": "3cf91c54e15d72934ced61a2459a723b"
  },
  {
    "url": "icons/ios/icon_114x114.png",
    "revision": "c1d9e553926aa0ba2d709eb7a0f5a3ec"
  },
  {
    "url": "icons/ios/icon_120x120.png",
    "revision": "51eb60da86694b45fabf114f99e58fc8"
  },
  {
    "url": "icons/ios/icon_152x152.png",
    "revision": "04e129473da8864ff9056c6e2e27cfb2"
  },
  {
    "url": "icons/ios/icon_167x167.png",
    "revision": "f36f1be6cb6fe5d31997384a80922712"
  },
  {
    "url": "icons/ios/icon_180x180.png",
    "revision": "5ee7b79b3ef0ee0d6077f1cbd45c5e34"
  },
  {
    "url": "icons/ios/icon_57x57.png",
    "revision": "71683206574e9aeda6eb283195c310f7"
  },
  {
    "url": "icons/ios/icon_60x60.png",
    "revision": "a49978ee29c0bd734a39b64807882650"
  },
  {
    "url": "icons/ios/icon_76x76.png",
    "revision": "ead51ef07386924ae34fbb5ee1c17869"
  },
  {
    "url": "icons/other/icon_150x150.png",
    "revision": "10574dee246af4e3d2300a8148ea397d"
  },
  {
    "url": "icons/other/icon_16x16.png",
    "revision": "f3f813607fced982a62f0c4ba65b7ab2"
  },
  {
    "url": "icons/other/icon_192x192.png",
    "revision": "b2e3fd1114f011e1b9209dffe9c611b2"
  },
  {
    "url": "icons/other/icon_310x310.png",
    "revision": "e00de42fb9c6ffaea17da1837e00ba08"
  },
  {
    "url": "icons/other/icon_32x32.png",
    "revision": "befc766e8dab6a5f0fb64073d8b71f34"
  },
  {
    "url": "icons/other/icon_70x70.png",
    "revision": "5a49ed3b4cc8082b18132fa542dd4b62"
  },
  {
    "url": "index.html",
    "revision": "bb9819bef561a83a83ecc7ffa808a78b"
  },
  {
    "url": "js/app-597d9f8d18f67eb83db8.js",
    "revision": "05680f6bf2f7d1014654aaed7cf1e2cc"
  },
  {
    "url": "offline.html",
    "revision": "87e2277899e55f890978537dff0bc57e"
  },
  {
    "url": "safari-pinned-tab.svg",
    "revision": "bc9fb68776ea60df49c19e5a3f38fa07"
  },
  {
    "url": "styles.css",
    "revision": "4a4271f4fad9e8b158f7ee81030ad82b"
  }
];

const workboxSW = new self.WorkboxSW();
workboxSW.precache(fileManifest);
workboxSW.router.registerNavigationRoute("/index.html");workboxSW.router.registerRoute(/^https:\/\/fonts\.gstatic\.com(.+)/, workboxSW.strategies.cacheFirst({}), 'GET');
workboxSW.router.registerRoute(/^https:\/\/fonts\.googleapis\.com(.+)/, workboxSW.strategies.cacheFirst({}), 'GET');
