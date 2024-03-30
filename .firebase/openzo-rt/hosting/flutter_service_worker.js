'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "e1ad32d06c62d6fc093c5111877f72dd",
"assets/AssetManifest.bin.json": "0a4e376f2a012c5b6ea88eff0ab7e40d",
"assets/AssetManifest.json": "bea599fc166a64814ba1ab28633899bb",
"assets/assets/images/2.0x/flutter_logo.png": "4efb9624185aff46ca4bf5ab96496736",
"assets/assets/images/3.0x/flutter_logo.png": "b8ead818b15b6518ac627b53376b42f2",
"assets/assets/images/Accessory%2520stores.png": "ae7b906868217d1ba77e4b69df8f74b6",
"assets/assets/images/All%2520in%2520one%2520stores.png": "b367f9dadae357fdb44983ffe1d3eb13",
"assets/assets/images/Beauty%2520and%2520products%2520store.png": "62b357af71fcdd880e24357bb06ff98d",
"assets/assets/images/Electronic%2520Stores/Cameras%2520and%2520equipment.png": "37d2cb1dffe7104b234fd906c22a889a",
"assets/assets/images/Electronic%2520Stores/Chargers%2520and%2520batteries.png": "ac795d830104bdfcc27b5ba3c4526a68",
"assets/assets/images/Electronic%2520Stores/Gaming%2520Accessories.png": "ec2ae40eb05b10694fbe025c8d1e77a7",
"assets/assets/images/Electronic%2520Stores/Headphones%2520and%2520earphones.png": "1f6c87da7e0124949a51db2be812390e",
"assets/assets/images/Electronic%2520Stores/Home%2520appliances.png": "d250a5ac2cff32274701cca204dbae2c",
"assets/assets/images/Electronic%2520Stores/Laptop%2520accessories.png": "d1b88383f32b0db5d64160e58a1ec90c",
"assets/assets/images/Electronic%2520Stores/Smart%2520phone%2520accessories.png": "fcf213646be8d61ad504a1c51bc73856",
"assets/assets/images/Electronic%2520Stores/Smartphones.png": "0e7f7a4534928fe9c0e1c2d8251d7de0",
"assets/assets/images/Electronic%2520Stores/Speakers.png": "1a41d9a8b3b541e83f3b26f5a3461481",
"assets/assets/images/Electronic%2520Stores/Wearables.png": "05cd5d450eea35ea0b81fdc6cd518eb6",
"assets/assets/images/Electronic%2520stores.png": "6bb5e27b371f16c8a29013347a02a666",
"assets/assets/images/Fashion%2520Stores/accessories.png": "8c878c3efd429efdfac5287a608382fb",
"assets/assets/images/Fashion%2520Stores/handbags_and_purses.png": "f089012e08fdda3862c057a96c362971",
"assets/assets/images/Fashion%2520Stores/jewelery.png": "8260992a82b59663be83bf3c131dc8a7",
"assets/assets/images/Fashion%2520Stores/kids_clothing.png": "93cc08eb3bba7fc6c23c28a5a87bf142",
"assets/assets/images/Fashion%2520Stores/mens_clothing.png": "8ab41812efd9b42ae9cb2413c03e93ef",
"assets/assets/images/Fashion%2520Stores/sunglasses.png": "9bf771738fe08f349e0e1e4061ed6d61",
"assets/assets/images/Fashion%2520Stores/womens_clothing.png": "1748bcd2b2cbf90530513680f298a9ed",
"assets/assets/images/Fashion%2520stores.png": "36bc48ea0a685fb92c1d043c68a3e677",
"assets/assets/images/flutter_logo.png": "478970b138ad955405d4efda115125bf",
"assets/assets/images/Foods%2520and%2520snacks.png": "8ab7429afa4689b45840d043e7f2e1d3",
"assets/assets/images/Footwear%2520Stores/boots_and_booties.png": "8442cfcb3e41a789cebbb7f733d43dae",
"assets/assets/images/Footwear%2520Stores/kids_shoes.png": "1fad2a561dc79d06a615f6e93f67f7dc",
"assets/assets/images/Footwear%2520Stores/mens_shoes.png": "c4675c41bfa395f4ec5c334ad545d9c8",
"assets/assets/images/Footwear%2520Stores/slippers.png": "00cc7036c0c35778766ad3864ab9579b",
"assets/assets/images/Footwear%2520Stores/Sport%2520shoes.png": "92d021cf2ce7819da69cfca365ec297d",
"assets/assets/images/Footwear%2520Stores/womens_shoes.png": "1cd689af91eeb03eef5a62ed6bf01896",
"assets/assets/images/Footwear%2520stores.png": "bc954c3c34fba1685722e2f202f4222d",
"assets/assets/images/General%2520Stores/Health%2520and%2520wellness.png": "e1fea0b80801b55b883820ff6851a91b",
"assets/assets/images/General%2520Stores/House%2520essentials.png": "ce4d382d72dc3fe1d9c9b881fd135f6b",
"assets/assets/images/General%2520Stores/Kitchen.png": "2a1a4430b70858d045492baa50acc58e",
"assets/assets/images/General%2520Stores/Office%2520essentials.png": "b789594fc54f81a4f7a4278cc60e4e92",
"assets/assets/images/General%2520Stores/Pantry.png": "050c0937b7e9af265f1dbc33c5d76a45",
"assets/assets/images/General%2520Stores/Pet%2520care.png": "6788ee5d9171a6a3b9f7c0efe2e9b0c1",
"assets/assets/images/General%2520Stores/Self%2520care.png": "73b41ecf77f4a24b1b9c5317617a77d7",
"assets/assets/images/General%2520Stores/Snacks%2520and%2520drinks.png": "391e9d60e96e311193dcb1fe21754c7e",
"assets/assets/images/General%2520Stores/Spices%2520and%2520powders.png": "6bfd2d9246f7d398975235dca4b09717",
"assets/assets/images/General%2520Stores/Toys.png": "ab0689a9bc640546dad1532323469b4b",
"assets/assets/images/General%2520stores%2520.png": "cd467421c822742fc39baea82e1f0048",
"assets/assets/images/General%2520stores.png": "1de9d5cadc7f196a664363201f6158c6",
"assets/assets/images/Grocery%2520stores.png": "3d6a8c115480be85b489d366887aa556",
"assets/assets/images/Internet%2520and%2520technology%2520stores.png": "a67bc180dc9bb8019b4870cf95b44c4b",
"assets/assets/images/Mini%2520super%2520markets.png": "bb172b8d5aad662724e6c292ceaaa2e0",
"assets/assets/images/Openzo%2520logo%252017.png": "4f0e2c04ccf891a9c1ef26c9225b0897",
"assets/assets/images/Openzo%2520logo%252018.png": "4f9414a21ab250505306f882fdf60e75",
"assets/assets/images/Openzo%2520users%2520app%2520logo.png": "24203893491c4571087d92121eaf3e1a",
"assets/assets/images/Rental%2520stores.png": "7777b35d851abe11baa1930b0c91be01",
"assets/assets/images/Stationary%2520store.png": "abe4f846917766aa384ecf8bf7c302a4",
"assets/assets/images/Stationary%2520Stores/art_supplies.png": "8d1c696aef7208515fcfbbca7e18d19c",
"assets/assets/images/Stationary%2520Stores/Bags.png": "90efc2a03f0763e1f4284fb8ead9e9c6",
"assets/assets/images/Stationary%2520Stores/calendars_and_planners.png": "49df69e0cf824968e0b889376cd6cbbd",
"assets/assets/images/Stationary%2520Stores/Classroom%2520essentials.png": "37a5b659aba97638bd3b6e6ead314a65",
"assets/assets/images/Stationary%2520Stores/crafting_materials.png": "bd3b1628b5cb7fb2cc320a60dddfe5e0",
"assets/assets/images/Stationary%2520Stores/desk_accessories.png": "f292b8a0b2c29d33d199b9c797af03c0",
"assets/assets/images/Stationary%2520Stores/filing_and_organization.png": "ad7f9b349425c74f3dc55825b0bc70ea",
"assets/assets/images/Stationary%2520Stores/notebooks_and_pads.png": "85cf82973d9aaf3d3657c1a86a0656e7",
"assets/assets/images/Stationary%2520Stores/school_supplies.png": "defc82d6b1f2fed22bca8683e6a1a407",
"assets/assets/images/Stationary%2520Stores/writing_instruments.png": "7b1112091d535ae97603d6107829d3c6",
"assets/assets/images/Stationary%2520stores.png": "3ef2b709fcd593d71855e85977bf7b7b",
"assets/assets/images/store.jpeg": "4b1ca416ed8203dc4e2a7fee09a31b4e",
"assets/assets/images/top/Hot%2520deals.png": "7462850aa588dec67a24f9dd69d20f82",
"assets/assets/images/top/Local%2520events.png": "2d49f39dd2dba33234c0d82d765240e6",
"assets/assets/images/top/Order%2520food.png": "48e78a829b8229cdcc962a2d5a70adf6",
"assets/assets/images/top/Products.png": "f04a3bff5350f98c6b6e8e719385312f",
"assets/assets/images/top/Rentals.png": "ba84b1d4b29b1f5ef25f3cd92729a7ae",
"assets/assets/images/top/Resell.png": "9d6299c01def31bc774221424397f150",
"assets/assets/images/top/Ride%2520Hail.png": "c0c3208aa2b1456ede5909349e815d5c",
"assets/assets/images/top/Services.png": "0ce071dbadd14f3d589e11dab0e76e3d",
"assets/assets/images/top/Stores.png": "a4709d327551babf81a151f31c87bbd5",
"assets/assets/images/watch.webp": "55c21fe878e20095f0028d63df07695b",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/fonts/MaterialIcons-Regular.otf": "083bf815759f0d72d5fa3b83ffe31827",
"assets/lib/icons/schedule.png": "c284145db8855882e16bfbc7f757f5c8",
"assets/NOTICES": "ca7616854337e86d8a2aaedeebabc045",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "c86fbd9e7b17accae76e5ad116583dc4",
"canvaskit/canvaskit.js.symbols": "38cba9233b92472a36ff011dc21c2c9f",
"canvaskit/canvaskit.wasm": "3d2a2d663e8c5111ac61a46367f751ac",
"canvaskit/chromium/canvaskit.js": "43787ac5098c648979c27c13c6f804c3",
"canvaskit/chromium/canvaskit.js.symbols": "4525682ef039faeb11f24f37436dca06",
"canvaskit/chromium/canvaskit.wasm": "f5934e694f12929ed56a671617acd254",
"canvaskit/skwasm.js": "445e9e400085faead4493be2224d95aa",
"canvaskit/skwasm.js.symbols": "741d50ffba71f89345996b0aa8426af8",
"canvaskit/skwasm.wasm": "e42815763c5d05bba43f9d0337fa7d84",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "c71a09214cb6f5f8996a531350400a9a",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "323aa0c4078741d9b7637c47b896d7a5",
"/": "323aa0c4078741d9b7637c47b896d7a5",
"main.dart.js": "3f764a58ca0f1886c27c449826689962",
"manifest.json": "621c901b2197dc70c714fefe2d01c9f2",
"version.json": "29e2540a5840651db32b8c396bd82ac2"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
