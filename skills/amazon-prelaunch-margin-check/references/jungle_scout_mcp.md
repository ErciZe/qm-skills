# Jungle Scout MCP tools used by Margin Reality Check

Market data comes from the host's read-only **Jungle Scout `js_*` MCP tools**.
You call the tools and read JSON yourself. No API keys live in this skill. If the
tools are not available, say so and stop — do not substitute another source.

Every tool takes an optional `marketplace` (default `us`; us, uk, de, in, ca, fr,
it, es, mx, jp). Prices, units, and revenue are modeled estimates, not actuals.

**Response envelope.** List endpoints return JSON:API-style envelopes:
`data[]` (each item has `id` + `attributes`), plus `meta.total_items` and
`links.next` for pagination. An empty `data[]` is a valid **observed empty**
result — not an error and not proof of zero demand. If the response has neither
the expected `data[]` array nor a recognizable legacy shape, treat it as schema
drift: stop, report the drift, do not guess field names. Exact attribute
availability can vary; read only the fields listed below and degrade gracefully
when one is absent.

This skill needs only one tool.

## `js_product_database_query` (competitor set + fee model)
Find competing listings and read each one's price and Amazon fees in a single
call.

- **Params:**
  - `include_keywords` — the product keyword(s), or an ASIN, to match.
  - `categories` — optional, exact category name(s) to narrow a broad keyword.
  - `min_reviews` — drop noise/new listings.
  - `min_price` / `max_price` — keep comps near the intended price point.
  - `sort` — e.g. `-revenue`.
  - `max_results` — up to 100.
  - `marketplace` — default `us`.
- **Returns (per product, in `attributes`):**
  - `asin`, `title`, `brand`, `category`, `price`, `reviews`, `rating`,
    `approximate_30_day_revenue`, `approximate_30_day_units_sold`.
  - `fee_breakdown`: `{ fba_fee, referral_fee, variable_closing_fee,
    total_fees }`. Treat it as optional; if a row lacks it, drop that row rather
    than estimating fees yourself.

Keep only rows that have both `price` and `fee_breakdown`. Then:
- referral **rate** `r` = median(`referral_fee` / `price`)
- FBA fee **scenarios** (competitor proxy, used only when the user has not
  provided the target unit's own FBA fee or size/weight):
  `fba_low` = p25, `fba_mid` = median, `fba_high` = p75 of `fba_fee`
  (fewer than ~8 usable comps: min / median / max). Label these as proxies —
  FBA fees depend on the target unit's own size, weight, and packaging — and
  report verdicts across all three scenarios, downgraded to "Provisional".
- fixed `closing` = median(`variable_closing_fee`)
- price band = min / median / p90 / max of `price`

`approximate_30_day_units_sold` is the parent (variant-family) total, not a
single variant — not needed for the margin math but useful context.

## Errors

- If a `js_*` call ever returns a low-level serialization error (e.g. `The "data" argument must be of type string ... Received an instance of Array`): this is a host-side transport issue, not a data problem and not a parameters problem — retry the call once (unchanged, or dropping `--raw` if it was present) before degrading the affected dimension.
Errors come back as `{ "error": { "code", "message" } }` — e.g.
`forbidden_marketplace` (key lacks that marketplace), `unknown_category`,
`throttled`. Report the gap, skip the affected step, and lower the confidence of
any dependent conclusion; never fabricate fees or prices.
