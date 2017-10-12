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
    "url": "android-chrome-192x192.png",
    "revision": "a6f6132a50fa49b4a8c59831f8242565"
  },
  {
    "url": "android-chrome-512x512.png",
    "revision": "176f069d12cac40962fe19cc0bb789c1"
  },
  {
    "url": "apple-touch-icon.png",
    "revision": "5911e77ae8fc069b4f1d26658c4d4361"
  },
  {
    "url": "favicon-16x16.png",
    "revision": "15992b2f602bb30217784c67371f51e6"
  },
  {
    "url": "favicon-32x32.png",
    "revision": "c28aa3f82ed2b76a58ed67033ed1a717"
  },
  {
    "url": "images/android-chrome-512x512.png",
    "revision": "deb4eed0be0639e52179b84747f2d323"
  },
  {
    "url": "images/android-icon-144x144.png",
    "revision": "b9e5210af0db511bd5dfd49e0f154da5"
  },
  {
    "url": "images/android-icon-192x192.png",
    "revision": "71b3d381fac662ebfa18bc0597d63e3a"
  },
  {
    "url": "images/android-icon-36x36.png",
    "revision": "625af43a5bfb270a82cfad4b6f3dd101"
  },
  {
    "url": "images/android-icon-48x48.png",
    "revision": "9bc2764b6a0d335c235a80427d56514a"
  },
  {
    "url": "images/android-icon-72x72.png",
    "revision": "ba7d5739bce6b7768603be88b305e889"
  },
  {
    "url": "images/android-icon-96x96.png",
    "revision": "77680c894f84dab3ff6a6257b2e11d9f"
  },
  {
    "url": "images/apple-icon-114x114.png",
    "revision": "efa43c193861f0124c68886a6502c4b6"
  },
  {
    "url": "images/apple-icon-120x120.png",
    "revision": "183852fea1b3d8662eeb32bc197c55c9"
  },
  {
    "url": "images/apple-icon-144x144.png",
    "revision": "b9e5210af0db511bd5dfd49e0f154da5"
  },
  {
    "url": "images/apple-icon-152x152.png",
    "revision": "dbe35ceb676982921f56acb16b431867"
  },
  {
    "url": "images/apple-icon-180x180.png",
    "revision": "d4ba4bb28158122fd646c35e8bf464b3"
  },
  {
    "url": "images/apple-icon-57x57.png",
    "revision": "3f6777c9ba50cc33648f949ab06ad288"
  },
  {
    "url": "images/apple-icon-60x60.png",
    "revision": "7b329a01a902df1f2fd742ce3a45fdfa"
  },
  {
    "url": "images/apple-icon-72x72.png",
    "revision": "ba7d5739bce6b7768603be88b305e889"
  },
  {
    "url": "images/apple-icon-76x76.png",
    "revision": "29973e15d81ef9a8e7f12cc02601c2d2"
  },
  {
    "url": "images/apple-icon-precomposed.png",
    "revision": "27cb2234dac6b97a339790d31a1ead48"
  },
  {
    "url": "images/apple-icon.png",
    "revision": "27cb2234dac6b97a339790d31a1ead48"
  },
  {
    "url": "images/favicon-16x16.png",
    "revision": "60ff3bd7f883131f5172c32cecf27c62"
  },
  {
    "url": "images/favicon-32x32.png",
    "revision": "f866098272235235bda8b536df0583ff"
  },
  {
    "url": "images/favicon-96x96.png",
    "revision": "77680c894f84dab3ff6a6257b2e11d9f"
  },
  {
    "url": "images/ms-icon-144x144.png",
    "revision": "b9e5210af0db511bd5dfd49e0f154da5"
  },
  {
    "url": "images/ms-icon-150x150.png",
    "revision": "2928d4d71e4b68c5fb69e0ff3fd42cb5"
  },
  {
    "url": "images/ms-icon-310x310.png",
    "revision": "731017c22582b7f283290b6c708a6568"
  },
  {
    "url": "images/ms-icon-70x70.png",
    "revision": "6f9e77b21335555ee2b7553ecae1c2a8"
  },
  {
    "url": "index.html",
    "revision": "8bfcf25a374c3fbcc3ce94e6b0fec74d"
  },
  {
    "url": "js/app-5eeef52c5d68f9e0120e.js",
    "revision": "b646e934952a71902907acb8f7bb7a40"
  },
  {
    "url": "mstile-150x150.png",
    "revision": "4734b977f66899ed54db0319cfeb984b"
  },
  {
    "url": "offline.html",
    "revision": "87e2277899e55f890978537dff0bc57e"
  },
  {
    "url": "safari-pinned-tab.svg",
    "revision": "f88ccd4d81027df0e476da2ae379a63f"
  },
  {
    "url": "styles.css",
    "revision": "4a4271f4fad9e8b158f7ee81030ad82b"
  }
];

const workboxSW = new self.WorkboxSW();
workboxSW.precache(fileManifest);
workboxSW.router.registerNavigationRoute("/offline.html");workboxSW.router.registerRoute(/^https:\/\/fonts\.gstatic\.com(.+)/, workboxSW.strategies.cacheFirst({}), 'GET');
workboxSW.router.registerRoute(/^https:\/\/fonts\.googleapis\.com(.+)/, workboxSW.strategies.cacheFirst({}), 'GET');
