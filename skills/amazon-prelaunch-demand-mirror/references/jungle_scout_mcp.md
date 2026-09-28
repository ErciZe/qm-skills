# Jungle Scout MCP tools used by Demand Mirror

All Amazon data comes from the host's read-only **Jungle Scout `js_*` MCP tools**.
You call the tools and read JSON yourself. No API keys live in this skill. If the
tools are not available, say so and stop — do not substitute another source or
fabricate numbers.

Every tool takes an optional `marketplace` (default `us`; us, uk, de, in, ca, fr,
it, es, mx, jp). Search volume, units, and revenue are modeled estimates —
directional, not exact.

**Response envelope.** List endpoints return JSON:API-style envelopes: `data[]`
(each item has `id` + `attributes`), plus `meta.total_items` and `links.next` for
pagination. An empty `data[]` is a valid **observed empty** result — not an error
and not proof of zero demand. If the response has neither the expected `data[]`
array nor a recognizable legacy shape, treat it as schema drift: stop, report the
drift, do not guess field names. Exact attribute availability can vary; read only
the fields listed below and degrade gracefully when one is absent.

## `js_keywords_by_keyword` (demand + related terms)
- **Params:** `search_terms` (the seed), optional `categories`, volume/word-count
  filters, `sort`, `max_results`.
- **Returns (per keyword, in `attributes`):** `keyword` (or `name`),
  `monthly_search_volume_exact`, `monthly_search_volume_broad`, `monthly_trend`
  (30-day %), `quarterly_trend` (90-day %), `dominant_category`,
  `organic_product_count`, `ppc_bid_exact`, `ease_of_ranking_score`,
  `relevancy_score`. The related set is the demand-side variant signal (filter
  for color/size tokens).

## `js_historical_search_volume` (seasonality)
- **Params:** `keyword`, `start_date`, `end_date` (`YYYY-MM-DD`). **A single call
  covers at most 366 days** — never request a longer range in one call. A
  ~12-month window for the seasonality curve fits in one call.
- **Returns:** weekly buckets `{ estimate_start_date, estimate_end_date,
  estimated_exact_search_volume }` (~52 rows/year). Aggregate to calendar months
  for the curve.

## `js_product_database_query` (top sellers, revenue, variant supply)
- **Params:** `include_keywords: [seed]`, optional `categories`, `sort` (e.g.
  `-revenue`), `max_results` (~15 for top sellers).
- **Returns (per product, in `attributes`):** `asin`, `title`, `brand`, `price`,
  `rating`, `reviews`, `product_rank`, `number_of_sellers`,
  `approximate_30_day_units_sold`, `approximate_30_day_revenue`,
  `date_first_available`, and (when present) `fee_breakdown`. For the
  supply-side variant signal, count how many top-listing `title`s contain each
  color/size token — a plain frequency count, never a per-variant split of
  units. Units/revenue are the parent (variant-family) total; see "Variant
  data boundary" below. Treat `fee_breakdown` as optional; if absent, omit
  fee-based claims rather than estimating fees yourself.

## `js_share_of_voice` (competitive context + price band)
- **Params:** `keyword`.
- **Returns:** `estimated_30_day_search_volume`, `product_count`, `brands[]`
  (with `combined_weighted_sov`, `combined_average_price`, …), `top_asins[]`.
  Use brand SOV concentration to judge how open the category is, and
  `combined_average_price` for the winning price band.

## `js_sales_estimates` (optional — corroborate seasonality)
- **Params:** `asin`, `start_date`, `end_date` (`YYYY-MM-DD`, ≤366 days per
  call). Never rely on server-side chunking of an over-long range.
- **Returns:** an object envelope such as `{ asin, …, data: [ { date,
  estimated_units_sold, last_known_price }, … ] }`. Aggregate daily units to
  months to corroborate the search-based seasonality. Returns the parent
  aggregate for a variant family.

## Variant data boundary
Units and revenue from `js_product_database_query` and `js_sales_estimates`
are **parent-ASIN aggregates** for the whole variant family. Direct,
reportable variant data is limited to: (1) search volume of keywords that
contain a color/size token; (2) color/size token frequency across top-listing
titles; (3) the parent ASIN's overall units/revenue as whole-family
corroboration. Everything else about a variant — the reconciled ranking,
opportunity gaps, missing-variant calls, mix alignment — is inference and must
be tagged `[inferred]` with evidence, assumption, and confidence. Never output
unit sales or revenue for a single color or size, and never distribute parent
totals across variants.

## Amazon vs Google data boundary
`js_keywords_by_keyword` and `js_historical_search_volume` return **Amazon
marketplace** search data. It supports Amazon demand conclusions only. For
own-channel copy you may borrow the consumer language, but these numbers are
not Google search volume, intent, or SEO difficulty. Google SEO conclusions
require a dedicated SEO/Search data source (or clearly-labeled web search when
the environment provides it) — never these tools.

## Seasonality thresholds (Jungle Scout standard)
Peak calendar-month share of annual volume: < 10% = **low**, 10–15% =
**moderate**, > 15% = **high**. High seasonality means time inventory carefully —
build *before* the peak.

## US category names
Use exactly when passing `categories`: Appliances; Arts, Crafts & Sewing;
Automotive; Baby; Beauty & Personal Care; Camera & Photo; Cell Phones &
Accessories; Clothing, Shoes & Jewelry; Computers & Accessories; Electronics;
Grocery & Gourmet Food; Health & Household; Home & Kitchen; Industrial &
Scientific; Kitchen & Dining; Musical Instruments; Office Products; Patio, Lawn &
Garden; Pet Supplies; Software; Sports & Outdoors; Tools & Home Improvement;
Toys & Games; Video Games. Other marketplaces use their own names; when unsure,
omit `categories`.

## Errors

- If a `js_*` call ever returns a low-level serialization error (e.g. `The "data" argument must be of type string ... Received an instance of Array`): this is a host-side transport issue, not a data problem and not a parameters problem — retry the call once (unchanged, or dropping `--raw` if it was present) before degrading the affected dimension.
Errors come back as `{ "error": { "code", "message" } }` — e.g.
`forbidden_marketplace`, `unknown_category`, `invalid_date_range` (> 366 days in
one call), `throttled`. Report the gap, skip the affected step, and lower the
confidence of any dependent conclusion; never fabricate missing data.
