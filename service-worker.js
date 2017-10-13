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
    "revision": "e40ce1dc6433b2f400eb850c26319dc0"
  },
  {
    "url": "icons/android/icon_192x192.png",
    "revision": "471249a031dd085165e733880c5f9d2f"
  },
  {
    "url": "icons/android/icon_36x36.png",
    "revision": "4a682233d298092826785d54ae04acf8"
  },
  {
    "url": "icons/android/icon_48x48.png",
    "revision": "9c12a4e112508c31a7030492e4208aff"
  },
  {
    "url": "icons/android/icon_512x512.png",
    "revision": "b14fff355593f5651459f058e2bf58b9"
  },
  {
    "url": "icons/android/icon_72x72.png",
    "revision": "4fc4b768ffdd7bb29e3ce414056f2bd0"
  },
  {
    "url": "icons/android/icon_96x96.png",
    "revision": "8a1d0af50eba58f0bfb74bb012453418"
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
    "revision": "c1a7c975af51bbbe74e8801b74ad220d"
  },
  {
    "url": "icons/other/icon_16x16.png",
    "revision": "d4febc81302e0f153777b005534c2a98"
  },
  {
    "url": "icons/other/icon_192x192.png",
    "revision": "471249a031dd085165e733880c5f9d2f"
  },
  {
    "url": "icons/other/icon_310x310.png",
    "revision": "3ffee08a08a75108358516f3d2ea790a"
  },
  {
    "url": "icons/other/icon_32x32.png",
    "revision": "1c7b09b263d89431366672b42bfa079f"
  },
  {
    "url": "icons/other/icon_70x70.png",
    "revision": "24a8937b04f35f3456b5d8c17f742970"
  },
  {
    "url": "index.html",
    "revision": "551f3fd4b4a2fbacc9c81dcb5298a8f6"
  },
  {
    "url": "js/app-bf4891564be1621a3afb.js",
    "revision": "76662588ae0763be6f4f040d821d1943"
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
