# Social Media Promotion Playbook

## Golden Rule

**Every post MUST include:**
1. An actual product mockup image (not generic/stock photos)
2. A direct link to the specific Etsy listing URL
3. Only promote products confirmed in real inventory

Never post generic "check out our shop" content without a specific product and link.

---

## Twitter/X

### Posting Method
Use the `post_tweet` tool via **`accio-mcp-cli`** (`accio-mcp-cli search twitter` to verify the tool name if needed):

```bash
accio-mcp-cli call post_tweet \
  --json '{"text":"Tweet text with listing URL","media_urls":["https://image-url-of-product-mockup.png"]}'
```

### Content Formula
```
{Emoji} {Hook/benefit statement}
{Product description, 1-2 lines}
{Call to action}
{Etsy listing URL}
{3-5 hashtags}
```

### Example
```
🌿 Transform your bathroom into a spa retreat

Our new Japanese Zen Bamboo art print brings instant calm to any space. Available in 6 sizes.

Shop now → https://www.etsy.com/listing/XXXXX

#WallArt #BathroomDecor #JapaneseAesthetic #HomeDecor #EtsyFinds
```

### Rate Limits
- ~3 tweets per burst before hitting 403 Forbidden
- Space tweets 15-30 minutes apart
- Target: 2-3 tweets per day

---

## Instagram

### Posting Method (Two-Step via Composio)

**Step 1: Create Media Container**
```bash
accio-mcp-cli call COMPOSIO_MULTI_EXECUTE_TOOL \
  --json '{"tools":[{"tool_slug":"INSTAGRAM_POST_IG_USER_MEDIA","arguments":{"image_url":"HTTPS_PUBLICLY_ACCESSIBLE_IMAGE_URL","caption":"Caption text with %23hashtags","ig_user_id":"YOUR_IG_USER_ID"}}]}'
```

**Step 2: Publish**
```bash
accio-mcp-cli call COMPOSIO_MULTI_EXECUTE_TOOL \
  --json '{"tools":[{"tool_slug":"INSTAGRAM_POST_IG_USER_MEDIA_PUBLISH","arguments":{"ig_user_id":"YOUR_IG_USER_ID","creation_id":"ID_FROM_STEP_1"}}]}'
```

### Critical Notes
- Image URLs must be publicly accessible HTTPS
- Hashtags must be URL-encoded: `%23` instead of `#`
- The `creation_id` from Step 1 is required for Step 2
- Target: 1-2 posts per day

### Caption Formula
```
{Hook line with emoji}

{2-3 lines about the product/design}

{Call to action — "Link in bio" or "Shop link in bio"}

{15-20 hashtags, URL-encoded with %23}
```

---

## Pinterest

### Posting Method (Browser Automation)

Pinterest's SPA architecture causes browser agent loops with direct pin creation. Use the "Save from URL" approach:

1. Navigate to `https://www.pinterest.com/pin-builder/?tab=save_from_url`
2. Enter the Etsy listing URL in the URL field
3. Click submit/save
4. Select the best product image from those loaded
5. Click "Add 1 Pin"
6. Click "Publish"

### Board Strategy
- Create a main board: "Wall Art & Home Decor" (or relevant category)
- Pin description should include keywords: product name, style, room, occasion
- Target: 2-3 pins per day

### Why Pinterest Matters
Pinterest is the #1 external traffic driver for Etsy shops. Pinterest users have high purchase intent and strong overlap with Etsy's buyer demographic.

---

## Content Calendar

| Day | Theme | Example |
|---|---|---|
| Monday | Home Decor | Living room wall art, bedroom prints |
| Tuesday | Mugs & Drinkware | Coffee mug designs, gift mugs |
| Wednesday | Seasonal/Trending | Current trend or upcoming holiday |
| Thursday | Gift Ideas | "Perfect gift for..." framing |
| Friday | New Arrivals | This week's newest designs |
| Saturday | Best Sellers | Top-performing products |
| Sunday | Behind the Scenes | Design process, shop story |

---

## Promotion Rotation

Avoid posting the same product repeatedly. Rotate through your catalog:

1. New products get promoted within 24 hours of listing
2. Each product gets promoted on all 3 platforms (Twitter, Instagram, Pinterest) over 3 days
3. After initial promotion, revisit top performers every 2 weeks
4. Seasonal products get extra promotion 2-4 weeks before the relevant date

---

## Measuring Impact

Track which social posts drive the most Etsy traffic:
- Etsy Stats → Traffic Sources → Direct & Other Traffic
- Compare traffic spikes with social posting times
- Double down on content types that drive visits
