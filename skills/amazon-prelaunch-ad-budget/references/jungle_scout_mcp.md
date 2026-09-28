# Jungle Scout MCP tools used by Ad Spend Planner

All data comes from the host's read-only **Jungle Scout `js_*` MCP tools**. You
call the tools and read JSON yourself. No API keys live in this skill. If the
tools are not available, say so and stop — do not substitute another source.

Every tool takes an optional `marketplace` (default `us`; one of us, uk, de,
in, ca, fr, it, es, mx, jp). Estimates (volume, CPC, conversion rate, price)
are modeled — good for planning and comparison, not exact accounting.

**Response envelope.** List endpoints return JSON:API-style envelopes:
`data[]` (each item has `id` + `attributes`), plus `meta.total_items` and
`links.next` for pagination. An empty `data[]` is a valid **observed empty**
result — not an error and not proof of zero demand. If the response has
neither the expected `data[]` array nor a recognizable legacy shape, treat it
as schema drift: stop, report the drift, do not guess field names. Exact
attribute availability can vary; read only the fields listed below and degrade
gracefully when one is absent.

This skill uses four tools.

## `js_keywords_by_asin`
Reverse-ASIN footprint: the keywords an ASIN ranks for.
- **Params:** `asins` (1–10), `include_variants` (bool), volume/word-count
  filters, `sort` (e.g. `-monthly_search_volume_exact`), `max_results`.
- **Returns (per keyword, in `attributes`):** `name` (or `keyword`),
  `monthly_search_volume_exact`, `monthly_search_volume_broad`,
  `monthly_trend`, `quarterly_trend`, `ppc_bid_exact`, `ppc_bid_broad`,
  `sp_brand_ad_bid`, `ease_of_ranking_score`, `relevancy_score`,
  `organic_product_count`, `sponsored_product_count`, `organic_rank`,
  `sponsored_rank`, `overall_rank`.

## `js_keywords_by_keyword`
Expand seed terms into related keywords.
- **Params:** `search_terms`, `categories`, the same volume/word-count
  filters, `sort` (default `-monthly_search_volume_exact`), `max_results`.
- **Returns:** the same keyword fields as `js_keywords_by_asin` minus the rank
  fields.

## `js_share_of_voice`
Brand share-of-voice and top ASINs for one keyword — the source of per-keyword
conversion rates and a suggested-bid cross-check.
- **Params:** `keyword`.
- **Returns:** `estimated_30_day_search_volume`,
  `exact_suggested_bid_median`, `product_count`, `brands[]`, and `top_asins[]`
  where each entry has `asin`, `name`, `brand`, `clicks`, `conversions`,
  `conversion_rate`. Average the `top_asins` `conversion_rate` for the
  keyword's CVR.

## `js_sales_estimates`
Daily units + price for one ASIN — used here only to read the latest price.
- **Params:** `asin`, `start_date`, `end_date` (`YYYY-MM-DD`; **a single call
  covers at most 366 days** — this skill only needs the last ~30 days, so one
  call suffices).
- **Returns:** an object envelope such as `{ asin, …, data: [ { date,
  estimated_units_sold, last_known_price }, … ] }`. Use the most recent
  `last_known_price` as the product's price when the user didn't supply one.

## Fields this skill consumes
CPC = `ppc_bid_exact` (fallback `ppc_bid_broad`); demand =
`monthly_search_volume_exact` (fallback `_broad`); CVR = mean `top_asins`
`conversion_rate` from `js_share_of_voice` (fallback default 0.10); price =
latest `last_known_price`; competition context = `sponsored_product_count`,
`organic_product_count`, `ease_of_ranking_score`.

## Errors

- If a `js_*` call ever returns a low-level serialization error (e.g. `The "data" argument must be of type string ... Received an instance of Array`): this is a host-side transport issue, not a data problem and not a parameters problem — retry the call once (unchanged, or dropping `--raw` if it was present) before degrading the affected dimension.
Errors come back as `{ "error": { "code", "message" } }` — e.g.
`invalid_asin`, `forbidden_marketplace`, `missing_rank_data`, `throttled`.
Report the gap, skip the affected step, and lower the confidence of any
dependent conclusion; never fabricate missing data.
