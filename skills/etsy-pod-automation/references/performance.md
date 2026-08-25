# Performance Monitoring & Optimization Guide

## Daily Monitoring Checklist

### 1. Etsy Stats Page
**URL:** `https://www.etsy.com/your/shops/me/stats?ref=seller-platform-mcnav`

Check and record:
- [ ] Total visits (today, this week, all time)
- [ ] Total views
- [ ] Orders and revenue
- [ ] Conversion rate (orders / visits)
- [ ] Traffic source breakdown (Etsy search %, direct %, social %, other %)
- [ ] Any trending listings (high view count)

### 2. Etsy Search Visibility Page
**URL:** `https://www.etsy.com/your/shops/me/search-visibility?ref=seller-platform-mcnav`

Check for:
- [ ] Photo warnings (listings with <2 photos)
- [ ] Title recommendations (review carefully — Etsy's AI often suggests wrong product types)
- [ ] Tag warnings (any listings with missing or incomplete tags)
- [ ] Description warnings
- [ ] Attribute warnings

**Important:** Etsy's automated title recommendations are sometimes incorrect. They may suggest renaming a poster as a "Mug" or vice versa. Always verify recommendations make sense before accepting them. Reject nonsensical suggestions.

### 3. Printify Orders
**API:** `GET https://api.printify.com/v1/shops/{SHOP_ID}/orders.json`

Check:
- [ ] New orders
- [ ] Fulfillment status of pending orders
- [ ] Any failed or cancelled orders

### 4. Search Analytics
**URL:** `https://www.etsy.com/your/shops/me/search-analytics`

Check for:
- [ ] Search terms bringing impressions
- [ ] Click-through rates per keyword
- [ ] Top-performing keywords to create more products for
- [ ] Keywords with impressions but low CTR (improve thumbnails/titles for these)

---

## Weekly Performance Review (Friday)

### Step 1: Ranking All Listings

Fetch all products and their external (Etsy) data:

```bash
# Get all products with their Etsy stats
for page in 1 2 3 4; do
  curl -s "https://api.printify.com/v1/shops/{SHOP_ID}/products.json?page=$page" \
    -H "Authorization: Bearer $TOKEN" | python3 -c "
import json, sys
data = json.load(sys.stdin)
for p in data.get('data', []):
    title = p.get('title', '')[:60]
    pid = p.get('id', '')
    tags = len(p.get('tags', []))
    imgs = len(p.get('images', []))
    bp = p.get('blueprint_id', 0)
    ptype = p.get('blueprint_id', 'UNKNOWN')  # Map to your product types
    print(f'{ptype} | Tags:{tags} | Imgs:{imgs} | {title}')
"
done
```

### Step 2: Identify Winners and Losers

**Winners (top 20%):**
- Listings with the most views, favorites, or sales
- Create variations: same design on different product types, same theme in different styles
- Boost with additional social media promotion

**Losers (bottom 20%):**
- Listings with 0 views after 14+ days
- Options:
  1. Optimize: update title, tags, add photos
  2. Retire: deactivate on Etsy (don't delete — reactivate for seasonal relevance)

### Step 3: Tag & Title Refresh

Based on search analytics data:
- Update tags for mid-performers using keywords that are actually driving traffic
- Adjust titles to include high-performing search terms in the first 40 characters
- Always republish after tag/title changes

---

## Monthly Strategy Review

### Financial Analysis
Calculate for the month:
- Total revenue
- Total COGS (Printify costs)
- Total Etsy fees
- Net profit
- Profit per product category (poster vs mug)
- Return rate per category

### Product Line Decisions

| Return Rate | Action |
|---|---|
| <1% | Excellent — expand this product line |
| 1-2% | Acceptable — maintain current approach |
| 2-3% | Monitor — review quality and descriptions |
| >3% | Action required — pause category, investigate root cause |

### Listing Audit
- Verify all listings have 13 tags
- Verify all mugs have 2+ photos
- Check for any seasonal listings that need updating
- Review pricing against competitors

---

## Key Performance Metrics & Targets

| Metric | New Shop (Month 1) | Established (Month 3+) |
|---|---|---|
| Conversion rate | 1-2% | 2-5% |
| Etsy search traffic % | 0-20% | 40-60% |
| Avg views/listing/day | 1-3 | 5-15 |
| Return rate | <2% | <2% |

Revenue targets depend on your product mix, pricing, and listing count. As a rough benchmark, shops with 100+ well-optimized listings typically see their first consistent sales within 4-8 weeks.

---

## Etsy Ads Strategy

### When to Start
- Wait until Etsy enables Ads for your shop (typically 15 days after opening)
- Start with $1-2/day budget
- Only advertise your 5-10 best-looking listings (best thumbnails, most complete listings)

### Why Ads Help New Shops
Ads "force" data into Etsy's algorithm. Even if the ads don't directly generate profitable sales, they teach Etsy who your ideal buyer is. This improves organic placement over time.

### Budget Guidelines
| Month | Daily Budget | Purpose |
|---|---|---|
| 1 | $1-2 | Data collection, algorithm training |
| 2 | $3-5 | Scale winners, pause losers |
| 3+ | Based on ROAS | Only continue if return on ad spend > 3x |

---

## Troubleshooting Low Traffic

### Zero Search Traffic (Normal for First 1-3 Weeks)
- Verify all listings have 13 tags (this is the #1 cause)
- Verify titles are descriptive and include product type
- Continue social media promotion to drive non-search traffic
- Etsy needs time to index new shops and listings

### Low Conversion Rate (<1%)
- Check photo quality — are thumbnails compelling?
- Check pricing — are you competitive?
- Add more photos (especially lifestyle photos for mugs)
- Improve descriptions with benefits and use cases

### High Return Rate (>3%)
- Check product descriptions for accuracy
- Verify mockup images match actual product quality
- Consider ordering a sample to check quality
- Review customer messages for common complaints
