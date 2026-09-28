# Methodology: how the budget and ACoS figures are computed

This file explains the model behind the Ad Spend Planner so the numbers are never
a black box. Read it when a user questions a figure, wants to change an
assumption, or asks why the plan looks the way it does.

## Goal

Answer one question: *before spending anything, what daily/monthly budget
should I plan for to advertise this product's main keywords, and can the
product afford the ACoS those keywords imply?* The output is an **advertising
test budget with keyword customer-acquisition scenarios**, not a guaranteed
"cost to rank" — the available data (volume, CPC, competition, CVR signals)
cannot establish that a given amount of ad spend lifts organic rank. Amazon
auction dynamics move, and the model is deliberately transparent so the
assumptions can be tuned.

## Inputs the model consumes

From the host's Jungle Scout `js_*` MCP tools:

- **CPC** per keyword — `ppc_bid_exact` (falls back to `ppc_bid_broad`). The
  cost the model assumes you pay per click. Share of Voice's
  `exact_suggested_bid_median` is pulled too, as a market cross-check, but the
  base CPC drives the math.
- **Monthly search volume** per keyword — `monthly_search_volume_exact` (falls
  back to broad). Converted to daily demand.
- **Conversion rate (CVR)** per keyword — the average `conversion_rate` of the
  keyword's top ASINs from Share of Voice, when available; otherwise a stated
  default (0.10). This is what turns clicks into orders.
- **Price** — most recent `last_known_price` from Sales Estimates for the
  ASIN, or a user-supplied price. Revenue per order. **No placeholder price is
  ever substituted**: without a price the budget math still runs (it doesn't
  need price) and ACoS is rendered as labeled price scenarios only (see
  "Price scenarios" below).
- **Competition context** — `sponsored_product_count`, `organic_product_count`,
  `ease_of_ranking_score`. Reported alongside each keyword so a human can judge
  difficulty; they don't alter the budget arithmetic directly.

From the user (not available from the MCP tools):

- **Pre-ad profit per unit** — price minus landed cost minus Amazon fees per
  unit, or equivalently a pre-ad margin %. Typically reused from a
  `amazon-prelaunch-margin-check` run. Required for breakeven and suggested target
  ACoS; without it those two figures are reported as *not computable* rather
  than estimated.

## The per-keyword math

For each main keyword *k*:

```
daily_searches          = monthly_search_volume / 30.4
target_clicks/d         = daily_searches * capture_rate
daily_spend             = target_clicks/d * CPC
daily_orders            = target_clicks/d * CVR
market_expected_ACoS    = daily_spend / (daily_orders * price)
                        = CPC / (price * CVR)
```

The `market_expected_ACoS` identity is worth internalizing: to get one order
you need `1/CVR` clicks costing `CPC/CVR`; that order earns `price`; so the
ad-cost-to-sales ratio is `CPC / (price * CVR)`. Search volume and capture
rate set the *scale* of spend; CPC, CVR, and price set the *efficiency*
(ACoS).

## Plan totals

```
starter_daily_budget   = sum(daily_spend over planned keywords)
starter_monthly_budget = starter_daily_budget * 30.4
launch_budget          = starter_daily_budget * launch_days
expected_ACoS          = sum(daily_spend) / sum(daily_orders * price)
```

`expected_ACoS` is the order-weighted blend of the per-keyword
market-expected ACoS, so high-volume keywords influence it more than
long-tail ones — which matches how a real campaign's blended ACoS behaves.

## The three ACoS numbers (do not collapse them)

An earlier version of this model labeled the blended expected ACoS as the
"target ACoS". That conflated a market observation with a business decision.
The correct treatment keeps three figures strictly separate:

1. **Market-expected ACoS** = `CPC / (price × CVR)`, blended across the
   planned keywords as above. This is what the market's current bids and
   estimated conversion rates imply for a campaign at price `P`. It is pure
   market signal — it says nothing about whether the product can afford it.
2. **Breakeven ACoS** = `pre_ad_profit_per_unit / price` — the contribution
   profit margin before ads. At exactly this ACoS, advertising consumes the
   entire pre-ad contribution profit; above it, every ad-attributed order
   loses money. This is the product's **affordable ceiling**, and it requires
   the profit input. If profit inputs are missing, breakeven is reported as
   *not computable* — never proxied from competitor data.
3. **Suggested target ACoS** — strictly below breakeven so ads leave profit:
   default `0.7 × breakeven_ACoS` for steady state (≈30% of contribution
   profit retained after ads). During a launch push the user may deliberately
   target breakeven or slightly above as a **time-boxed test** with its own
   capped budget — allowed, but it must be labeled as a deliberate
   loss-tolerating test, not as a sustainable setting.

The **affordability verdict** compares (1) against (2) per price scenario:

- `market_expected_ACoS < breakeven_ACoS` → profitable ads are plausible at
  current market costs; state the margin left per ad order.
- `market_expected_ACoS ≥ breakeven_ACoS` → ads lose money per order at
  current CPC/CVR; the plan is only justifiable as a capped, time-boxed test.
- No real price or no profit input → no verdict; state that profitability is
  not yet judgeable.

## Price scenarios (when no price is available)

Without a real price, a single ACoS figure is false precision. The model
therefore splits the output into two tiers:

- **Computable without price:** CPCs, target clicks/day, orders/day, and the
  daily/monthly/launch budgets. Report these normally.
- **Not judgeable without price:** any ACoS, the breakeven/target pair, and
  the profitability verdict. Render ACoS across 2–4 **labeled price
  scenarios** spanning the niche's plausible range — anchored on competitor
  prices when available (e.g. `js_sales_estimates` on top ASINs from Share of
  Voice), otherwise clearly marked illustrative values — or ask the user for
  the price and re-run. The output must state: "ad budget: computable;
  profitability: not yet judgeable."

## The levers (and how to choose them)

- **`capture_rate` (default 0.03)** — the single biggest lever. It's the share
  of a keyword's daily searches you intend to win as ad clicks during the
  launch push. Read it as roughly *sponsored-ad CTR × impression share*: even
  a top sponsored placement converts only a few percent of searchers into
  clicks, so 0.02–0.05 is a normal launch and 0.05–0.10 is aggressive (buying
  visibility fast, likely above breakeven). Note that for very high-volume
  head terms even 0.03 implies a large absolute click count and a large budget
  — that is real signal that competing on the head term is expensive, and the
  per-keyword table lets a user trim those terms. Because budget scales
  linearly with capture rate, doubling it doubles the budget but does **not**
  change ACoS (ACoS is independent of scale).
- **`default_cvr` (default 0.10)** — only used where Share of Voice returns no
  conversion rate. ~10% is a reasonable Amazon baseline, but mature/branded
  listings convert higher and brand-new ones lower. Lower CVR raises ACoS and
  raises the clicks (hence spend) needed per order.
- **`target_acos_ratio` (default 0.7)** — the fraction of breakeven ACoS used
  as the suggested target. Raise it (toward 1.0) for an aggressive launch test
  that tolerates breakeven-level ads; lower it when the product needs thicker
  post-ad margin.
- **`launch_days` (default 30)** — only scales the one-figure launch budget; it
  does not affect daily budget or ACoS.
- **`num_keywords` (default 15)** — how many of the top keywords (by volume)
  enter the plan. More keywords = bigger total budget and a blended ACoS that
  pulls toward the long tail.
- **`min_volume` (default 50)** — filters out negligible keywords so the plan
  isn't padded with noise.

## Why this shape

A launch budget question is really "how many clicks do I need to buy, at what
price, and will the resulting ad efficiency leave the product any profit?"
Framing the budget as *a share of each keyword's own daily demand* keeps it
grounded in real search behavior rather than an arbitrary dollar figure,
scales naturally from niche to broad keywords, and exposes exactly one
aggressiveness dial (capture rate) that a user can reason about. The
three-ACoS split keeps market signal (expected), product economics
(breakeven), and the recommended setting (target) from contaminating each
other — an efficient market is only good news if the product's margin can pay
for it.

## Limitations to be honest about

- CPC is a current bid estimate; real auction prices vary by time, placement,
  and competitor behavior.
- Capture rate is a planning assumption, not a guaranteed click share — actual
  impression share depends on bids, budgets, and relevance.
- Default CVR is a placeholder; a real conversion rate (Share of Voice or the
  seller's own data) materially improves the ACoS estimate.
- **No causal ranking model.** Nothing in the data shows that X ad clicks or
  orders produce Y organic rank positions. Ranking goals in the output are
  experimental hypotheses paired with to-be-verified metrics (e.g. weekly
  organic rank on the target keywords), never promised outcomes or "costs to
  rank".
- **Breakeven and target ACoS need real economics.** Without a real price and
  a pre-ad profit input they are reported as not computable; ACoS values from
  price scenarios are illustrations of market economics at those price points,
  not estimates of the product's actual efficiency.
- The model covers Sponsored Products-style keyword spend; it does not model
  Sponsored Brands/Display, coupons, or external traffic.

State the relevant caveats in the brief rather than burying them — a budget the
user can interrogate is one they can trust and adjust.
