/**
 * logger.js — Development Logger
 * ==================================
 * Structured activity logger for build-time and runtime diagnostics.
 * Entirely separate from application code — include or exclude without
 * affecting any UI or business logic.
 *
 * Entries are buffered in memory and flushed to sessionStorage only on
 * beforeunload (or manually via Logger.flush()), avoiding synchronous
 * storage I/O on every log call.
 *
 * Storage:
 *   Active session logs → sessionStorage (cleared on tab close)
 *   Summary snapshot    → localStorage   (persists across sessions)
 *
 * Usage:
 *   Logger.log('section', 'message', { optional: 'data' });
 *   Logger.time('hero-image');              // start named timer
 *   Logger.timeEnd('hero-image');           // stop timer, log elapsed ms
 *   Logger.flush();                         // write buffer to sessionStorage now
 *   Logger.dump();                          // print all entries to console
 *   Logger.clear();                         // wipe buffer + sessionStorage
 *
 * To remove: delete this file and remove <script src="js/logger.js"> from HTML.
 */

const Logger = (() => {
    'use strict';

    const SESSION_KEY = 'whl_dev_log';
    const PERSIST_KEY = 'whl_dev_log_summary';

    // In-memory buffer — flushed to sessionStorage only on unload
    const _buf    = [];
    const _timers = {};

    // ── Helpers ───────────────────────────────────────────────────────────────

    function _ts() {
        return new Date().toISOString();
    }

    // ── Public API ─────────────────────────────────────────────────────────────

    /**
     * Log a named event with an optional data payload.
     * @param {string} section  - Logical category, e.g. 'init', 'nav', 'perf'
     * @param {string} message  - Human-readable description
     * @param {*}      [data]   - Optional structured data (object, string, etc.)
     */
    function log(section, message, data) {
        const entry = { ts: _ts(), section, message };
        if (data !== undefined) entry.data = data;
        _buf.push(entry);
        // No synchronous storage write here — see flush()
    }

    /**
     * Start a named performance timer.
     * @param {string} name - Timer identifier
     */
    function time(name) {
        _timers[name] = performance.now();
        log('timer', `start: ${name}`);
    }

    /**
     * Stop a named timer and log the elapsed milliseconds.
     * @param   {string}      name - Timer identifier (must match a previous time() call)
     * @returns {number|null}       Elapsed ms, or null if the timer was never started
     */
    function timeEnd(name) {
        if (!(name in _timers)) {
            console.warn(`[Logger] timeEnd called for unknown timer: "${name}"`);
            return null;
        }
        const elapsed = +(performance.now() - _timers[name]).toFixed(2);
        delete _timers[name];
        log('timer', `end: ${name}`, { elapsed_ms: elapsed });
        return elapsed;
    }

    /**
     * Flush in-memory buffer to sessionStorage.
     * Called automatically on beforeunload; call manually before expected crashes.
     */
    function flush() {
        try {
            sessionStorage.setItem(SESSION_KEY, JSON.stringify(_buf));
        } catch (e) {
            console.warn('[Logger] sessionStorage flush failed:', e.message);
        }
    }

    /**
     * Print all buffered log entries to the browser console.
     * @returns {Array} The full entry array (useful in console REPL)
     */
    function dump() {
        console.group('[Logger] Session log dump');
        _buf.forEach(e =>
            console.log(`[${e.ts}] [${e.section}] ${e.message}`, e.data || '')
        );
        console.groupEnd();
        return _buf;
    }

    /**
     * Clear the in-memory buffer and sessionStorage.
     */
    function clear() {
        _buf.length = 0;
        try { sessionStorage.removeItem(SESSION_KEY); } catch { /* noop */ }
    }

    // ── Flush on unload ────────────────────────────────────────────────────────

    window.addEventListener('beforeunload', () => {
        flush();
        try {
            const summary = {
                saved_at: _ts(),
                url:      location.href,
                count:    _buf.length,
                entries:  _buf,
            };
            localStorage.setItem(PERSIST_KEY, JSON.stringify(summary));
        } catch { /* noop — storage may be full or restricted */ }
    });

    // ── Self-test on init ──────────────────────────────────────────────────────
    // Buffered only — zero synchronous storage I/O at startup.

    (function selfTest() {

        log('logger', 'Logger initialised', { mode: 'buffered', key: SESSION_KEY });

        // localStorage availability
        try {
            localStorage.setItem('_whl_test', '1');
            localStorage.removeItem('_whl_test');
            log('storage', 'localStorage: available');
        } catch {
            log('storage', 'localStorage: unavailable or blocked');
        }

        // sessionStorage availability
        try {
            sessionStorage.setItem('_whl_test', '1');
            sessionStorage.removeItem('_whl_test');
            log('storage', 'sessionStorage: available');
        } catch {
            log('storage', 'sessionStorage: unavailable or blocked');
        }

        // Navigation / page load timing
        const navEntry = performance.getEntriesByType('navigation')[0];
        if (navEntry) {
            log('perf', 'page load timing', {
                domContentLoaded_ms: +navEntry.domContentLoadedEventEnd.toFixed(2),
                load_ms:             +navEntry.loadEventEnd.toFixed(2),
                ttfb_ms:             +(navEntry.responseStart - navEntry.requestStart).toFixed(2),
            });
        }

        // Hero image load time — measured via PerformanceObserver on the first img
        // in main. Adapt selector to your hero element.
        try {
            const heroImg = document.querySelector('main img');
            if (heroImg) {
                if (heroImg.complete) {
                    log('perf', 'hero image: already loaded (from cache or fast connection)');
                } else {
                    Logger.time('hero-image');
                    heroImg.addEventListener('load',  () => Logger.timeEnd('hero-image'), { once: true });
                    heroImg.addEventListener('error', () => {
                        Logger.timeEnd('hero-image');
                        log('perf', 'hero image: load error');
                    }, { once: true });
                }
            }
        } catch { /* noop — no hero image */ }

        // Script loading time — log when this script itself finished executing
        log('perf', 'logger.js executed', {
            script_exec_ms: +performance.now().toFixed(2)
        });

    }());

    return { log, time, timeEnd, flush, dump, clear };

})();
