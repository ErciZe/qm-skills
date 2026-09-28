# Teardown report template

Fill this in from the data you gathered via the host's Jungle Scout `js_*` MCP tools. Keep prose tight and
lead with numbers. The two sections readers care about most are **Where they're weak** and
**How to position around them** — make those the strongest. Omit a row only when the data is
genuinely missing (and note it).

```markdown
# Competitor Teardown — <Target name> (<ASIN or "brand">)
**Marketplace:** <us> · **Window:** <start> → <end> (<N> days) · **Generated:** <date>

## Snapshot
| | |
|---|---|
| Brand / ASIN | <brand> / <asin> |
| Category | <category> |
| Price (current) | $<price> |
| Rating | <rating>★ across <reviews> reviews |
| ~30-day revenue / units | $<rev> / <units> |
| Listing Quality Score | <lqs> |
| Sellers / Buy Box | <n_sellers> / <buy_box_owner> |
| First available | <date_first_available> |

One-paragraph read: what kind of competitor is this (category leader, mid-tier, fading
incumbent, promo-driven challenger), in plain language, backed by the figures above.

## Revenue & momentum
Trailing-window units and revenue, the momentum read (<growing/flat/declining>, <±X%>
units vs the prior period), and any seasonality visible in the daily series. State the
trajectory in one clear sentence.

## Price & value posture
Current price vs peer average (from Share of Voice). Price range $<min>–$<max>, volatility
<price_cv_pct>%, discount days <discount_days> (<discount_day_pct>% of the window), deepest
discount <deepest_discount_pct>%. Fee load from `fee_breakdown` vs price. What this says
about their margin room and how reliant they are on promotions.

## Keyword footprint
How many keywords they index for, total addressable exact search volume, and their top
terms (a short table: keyword · exact volume · their rank · exact PPC bid). Note PPC cost
posture (avg/max exact bid) and how much of their volume is branded
(<branded_volume_share_pct>%).

## Review signal
Rating and review count, read as a quality signal vs the category. State explicitly that
the Jungle Scout tools do not expose review text, so this is metric-based and can only show
that a problem *may* exist. If web search was available and used, summarize the confirmed
complaint themes here with their source URLs, marked as web-sourced evidence; otherwise
point the user to the competitor's recent 1–3★ reviews as the verification path.

## Where they're weak  ← core
For each lens with real evidence, a tight bullet: the weakness, the number that proves it,
and how exposed it makes them. Every bullet ends with its evidence status and confidence.
Cover as many as the data supports:
- **Feature/quality:** … — each specific feature/material/quality weakness is tagged
  either `[Hypothesis to verify — verification path: <which reviews/pages to check>]` or
  `[Web-confirmed — source: <URL>]`, plus a confidence level. Never state a specific defect
  as fact from rating/review-count metrics alone.
- **Price/value:** …
- **Keyword coverage:** … (call out the top whitespace terms by name)
- **Momentum/distribution:** …

## How to position around them  ← core
3–6 concrete, prioritized moves, each tied to a weakness above. Make them specific enough
to act on (e.g. "rank and bid on '<term>' — 168k searches/mo where they sit at rank 41 and
hold 6% SOV; their 4.0★ rating across 8k reviews signals unresolved complaints — lead the
listing on the confirmed/hypothesized friction named in Where they're weak"). Order by
impact.

## Data & confidence
Window and marketplace; that revenue/units are Jungle Scout estimates; the review-theme
limitation (which weakness items remain `Hypothesis to verify` vs which are
`Web-confirmed`, with sources); and any data gaps (missing matches, tool errors, partial
coverage, etc.).
```
