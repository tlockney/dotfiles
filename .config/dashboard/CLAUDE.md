# Dashboard

A single-file browser dashboard (`index.html`) designed as a personal new-tab homepage. No build process, no server, no dependencies — just open the file in a browser.

## Usage

```bash
open ~/.config/dashboard/index.html
```

Or set it as your browser's homepage/new-tab page.

## Architecture

Everything lives in `index.html`: HTML structure, CSS styles, and JavaScript. The page loads instantly with the clock and greeting, then fetches data from external APIs to populate the remaining cards.

### Cards

- **Greeting & Clock** — live clock, date, moon phase (pure JS, no API)
- **Weather** — Open-Meteo API (free, no key, CORS-friendly)
- **Word of the Day** — Wiktionary HTML scraping
- **Featured on Wikipedia** — Wikimedia featured article API
- **On This Day** — Wikimedia featured feed (same endpoint as Wikipedia)

### Key Design Patterns

- **localStorage caching** — API responses are cached with TTLs (5 min for weather, 1 hour for others) to avoid hammering APIs on every tab open
- **`Promise.allSettled`** — all fetches run in parallel; failures are independent and cards show "Loading..." text on failure
- **No framework** — vanilla HTML/CSS/JS, zero dependencies
- **Time-aware background** — subtle RGB shifts in the body background based on hour of day

## Configuration

Edit the constants at the top of the `<script>` block in `index.html`:

- `LAT` / `LON` — coordinates for weather (default: Corvallis, OR)
- `LOCATION` — display name for the weather card
- `FIVE_MIN` / `ONE_HOUR` — cache TTLs

## External APIs Used

All APIs are free and require no keys:

- `api.open-meteo.com` — weather + forecast + sunrise/sunset
- `api.wikimedia.org` — featured article + on this day
- `en.wikipedia.org` — random article fallback
- `en.wiktionary.org` — word of the day
