// ============================================================
// VNC PLATFORM — FLUTTER SERVICE WORKER
// File: frontend/web/flutter_service_worker.js
// FINAL MASTER HARD-LOCK v6.7.0.4
// ============================================================

// NOTE:
// This is a minimal, safe service worker configuration.
// It avoids aggressive caching to prevent stale builds,
// which is critical for financial / regulated apps.

const CACHE_NAME = 'vnc-platform-cache-v6.7.0.4';
const CORE_ASSETS = [
  '/',
  '/index.html',
  '/manifest.json',
  '/flutter.js',
];

// Install: cache only core shell
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(CORE_ASSETS);
    })
  );
  self.skipWaiting();
});

// Activate: clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
          return null;
        })
      )
    )
  );
  self.clients.claim();
});

// Fetch: network-first (NO stale financial UI)
self.addEventListener('fetch', (event) => {
  const { request } = event;

  // Only handle GET requests
  if (request.method !== 'GET') {
    return;
  }

  event.respondWith(
    fetch(request)
      .then((response) => {
        // Clone and update cache in background
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(request, responseClone);
        });
        return response;
      })
      .catch(() => {
        // Fallback to cache only if network fails
        return caches.match(request);
      })
  );
});
