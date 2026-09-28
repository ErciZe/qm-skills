# Jungle Scout MCP tools used by Competitor Teardown

All data comes from the host's read-only **Jungle Scout `js_*` MCP tools**. You
call the tools and read JSON yourself. No API keys live in this skill. If the
tools are not available, say so and stop — do not substitute another source.

Every tool takes an optional `marketplace` (default `us`; us, uk, de, in, ca,
fr, it, es, mx, jp). Revenue, units, search volume, and SOV are modeled
estimates — directional, not exact.

**Response envelope.** List endpoints return JSON:API-style envelopes:
`data[]` (each item has `id` + `attributes`), plus `meta.total_items` and
`links.next` for pagination — follow `links.next` until it is absent when you
need more than one page. An empty `data[]` is a valid **observed empty**
result — not an error and not proof of zero demand or a dead competitor. If the
response has neither the expected `data[]` array nor a recognizable legacy
shape, treat it as schema drift: stop, report the drift, do not guess field
names. Exact attribute availability can vary; read only the fields listed below
and degrade gracefully when one is absent.

This skill uses four tools.

## `js_product_database_query` (snapshot / brand catalog)
Snapshot one ASIN (pass it in `include_keywords`) or find a brand's catalog
(pass the brand name, `sort: -revenue`, then filter rows by `brand`).
- **Params:** `include_keywords` (keywords or ASINs), `categories`, `sort`
  (e.g. `-revenue`), min/max filters, `max_results`.
- **Returns (per product, in `attributes`):** `asin`, `title`, `brand`,
  `category`, `price`, `rating`, `reviews`, `variant_reviews`, `product_rank`,
  `subcategory_ranks`, `listing_quality_score`, `number_of_sellers`,
  `buy_box_owner`, `buy_box_owner_seller_id`, `date_first_available`,
  `approximate_30_day_revenue`, `approximate_30_day_units_sold`,
  `is_parent`/`is_variant`/`is_standalone`, `parent_asin`, `variants`,
  `seller_type`, weight/dimension fields, `fee_breakdown` (`fba_fee`,
  `referral_fee`, `variable_closing_fee`, `total_fees`), `image_url`,
  `updated_at`. Treat `fee_breakdown` as optional; if absent, omit fee-based
  claims rather than estimating fees yourself.

## `js_sales_estimates` (daily units + price for one ASIN)
Source for price stats, volatility, discount cadence, trailing revenue, and
momentum.
- **Params:** `asin`, `start_date`, `end_date` (`YYYY-MM-DD`). **A single call
  covers at most 366 days** — never request a longer range in one call. The
  default 365-day teardown window fits in one call; if you ever need more, make
  multiple calls with a small overlap, merge, dedupe by `date`, and sort
  ascending.
- **Returns:** an object envelope such as `{ asin, is_parent, is_variant,
  is_standalone, parent_asin, variants, data: [ { date, estimated_units_sold,
  last_known_price }, … ] }`.

## `js_keywords_by_asin` (the reverse-ASIN keyword footprint)
- **Params:** `asins` (1–10), `include_variants`, volume/word-count filters,
  `sort` (e.g. `-monthly_search_volume_exact`), `max_results`.
- **Returns (per keyword, in `attributes`):** `name`,
  `monthly_search_volume_exact`, `monthly_search_volume_broad`,
  `monthly_trend`, `quarterly_trend`, `ppc_bid_exact`, `ppc_bid_broad`,
  `ease_of_ranking_score`, `relevancy_score`, `organic_product_count`,
  `sponsored_product_count`, `organic_rank`, `sponsored_rank`, `overall_rank`.
  A blank/high rank on a high-volume term = a coverage gap.

## `js_share_of_voice` (who owns a keyword + peer price band)
- **Params:** `keyword`.
- **Returns:** `estimated_30_day_search_volume`, `exact_suggested_bid_median`,
  `product_count`, `brands[]` (each: `brand`, `combined_weighted_sov`,
  `combined_basic_sov`, `combined_average_price`, `combined_average_position`,
  `organic_weighted_sov`, `sponsored_weighted_sov`, `organic_products`,
  `sponsored_products`), `top_asins[]` (each: `asin`, `name`, `brand`,
  `clicks`, `conversions`, `conversion_rate`). SOV values are fractions
  (0.243 = 24.3%).

## Errors

- If a `js_*` call ever returns a low-level serialization error (e.g. `The "data" argument must be of type string ... Received an instance of Array`): this is a host-side transport issue, not a data problem and not a parameters problem — retry the call once (unchanged, or dropping `--raw` if it was present) before degrading the affected dimension.
Errors come back as `{ "error": { "code", "message" } }` — e.g. `invalid_asin`,
`forbidden_marketplace`, `missing_rank_data` (retry later),
`invalid_date_range` (> 366 days in one call), `throttled`. Report the error as
a data gap, skip the affected step, and lower the confidence of any dependent
conclusion; never fabricate missing data.
