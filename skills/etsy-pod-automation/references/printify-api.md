# Printify API Reference & Product Creation Guide

## Authentication

All requests require the Bearer token from `project/.env`:

```bash
TOKEN=$(grep PRINTIFY_API_TOKEN project/.env | cut -d'=' -f2)
```

Base URL: `https://api.printify.com/v1`

Headers for all requests:
```
Authorization: Bearer $TOKEN
Content-Type: application/json
```

---

## Discovering Your Shop & Product Catalog

### Step 0: Find Your Shop ID

```bash
curl -s "https://api.printify.com/v1/shops.json" \
  -H "Authorization: Bearer $TOKEN"
```

Returns an array of shops. Save the `id` field as your `SHOP_ID`.

### Step 1: Browse Available Product Types (Blueprints)

```bash
# List all available product blueprints
curl -s "https://api.printify.com/v1/catalog/blueprints.json" \
  -H "Authorization: Bearer $TOKEN"
```

Each blueprint represents a product type (poster, mug, t-shirt, tote bag, etc.). Note the `id`, `title`, and `description`.

**Recommended starting blueprints** (low return risk, high margin):
- Posters / Art Prints — search for "poster", "art print", "enhanced matte"
- Mugs — search for "mug", "ceramic"
- Stickers — search for "sticker"

### Step 2: Find Print Providers for a Blueprint

```bash
curl -s "https://api.printify.com/v1/catalog/blueprints/{BLUEPRINT_ID}/print_providers.json" \
  -H "Authorization: Bearer $TOKEN"
```

Compare providers by: location (affects shipping time), pricing, and quality reviews.

### Step 3: Get Variants and Pricing

```bash
curl -s "https://api.printify.com/v1/catalog/blueprints/{BLUEPRINT_ID}/print_providers/{PROVIDER_ID}/variants.json" \
  -H "Authorization: Bearer $TOKEN"
```

Each variant has:
- `id` — the variant ID you'll use when creating products
- `title` — size/color description
- `options` — detailed attributes
- `placeholders` — print areas with dimensions

### Step 4: Get Production Costs

```bash
curl -s "https://api.printify.com/v1/catalog/blueprints/{BLUEPRINT_ID}/print_providers/{PROVIDER_ID}/shipping.json" \
  -H "Authorization: Bearer $TOKEN"
```

**CRITICAL:** Always look up actual production and shipping costs before setting prices. Costs vary significantly between providers and variants. Use the pricing formula from SKILL.md to calculate your retail price.

### Save Your Configuration

After discovering your blueprints, providers, and variants, save them to MEMORY.md:

```markdown
## Printify Configuration
- Shop ID: {YOUR_SHOP_ID}
- Product Type 1: {name}
  - Blueprint: {id}, Provider: {id}
  - Variants: {id}({size/color}), {id}({size/color}), ...
  - Production cost: ${X.XX} per unit
  - Retail price: ${XX.XX}
- Product Type 2: ...
```

---

## End-to-End Product Creation

### Step 1: Generate AI Design

Use `image_generate` with a detailed prompt specifying:
- Art style (watercolor, minimalist line art, vintage, etc.)
- Color palette
- Subject matter
- Composition (centered, pattern, typography, etc.)

Example prompt for a poster:
```
Elegant watercolor botanical illustration of March birth flower daffodils. 
Soft yellow petals with green stems on a clean white background. 
Delicate, feminine style suitable for wall art print. 
High resolution, centered composition.
```

Example prompt for a mug design:
```
Cute watercolor illustration of a sleeping orange tabby cat curled up.
Clean white background, centered design suitable for wrapping around 
an 11oz ceramic coffee mug. Warm, cozy aesthetic.
```

**Tip:** Specify the product type in your prompt to get the right composition. Mugs need wrap-around designs; posters need portrait/landscape orientation.

### Step 2: Upload Image to Printify

```bash
curl -s -X POST "https://api.printify.com/v1/uploads/images.json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "file_name": "design-name.png",
    "url": "IMAGE_URL_FROM_GENERATOR"
  }'
```

Response contains `id` — save this as the image ID for the product.

### Step 3: Create Product

```bash
curl -s -X POST "https://api.printify.com/v1/shops/{SHOP_ID}/products.json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Product Title: Key Descriptors, Use Case, Style",
    "description": "HTML description with features and benefits",
    "blueprint_id": YOUR_BLUEPRINT_ID,
    "print_provider_id": YOUR_PROVIDER_ID,
    "variants": [
      {"id": VARIANT_ID_1, "price": PRICE_IN_CENTS, "is_enabled": true},
      {"id": VARIANT_ID_2, "price": PRICE_IN_CENTS, "is_enabled": true}
    ],
    "print_areas": [
      {
        "variant_ids": [VARIANT_ID_1, VARIANT_ID_2],
        "placeholders": [
          {
            "position": "front",
            "images": [
              {
                "id": "UPLOADED_IMAGE_ID",
                "x": 0.5, "y": 0.5,
                "scale": 1,
                "angle": 0
              }
            ]
          }
        ]
      }
    ],
    "tags": [
      "tag1", "tag2", "tag3", "tag4", "tag5",
      "tag6", "tag7", "tag8", "tag9", "tag10",
      "tag11", "tag12", "tag13"
    ]
  }'
```

**Notes:**
- `price` is in **cents** (e.g. 1999 = $19.99)
- Look up variant IDs from Step 3 of the catalog discovery
- Look up production costs from Step 4 and calculate price using the pricing formula in SKILL.md
- **CRITICAL:** Always include the `tags` array with exactly 13 tags. Use the tag generation algorithm from `references/seo-tags.md`.

### Step 4: Publish to Etsy

```bash
curl -s -X POST "https://api.printify.com/v1/shops/{SHOP_ID}/products/{PRODUCT_ID}/publish.json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":true,"description":true,"images":true,"variants":true,"tags":true}'
```

An empty `{}` response means success.

### Step 5: Update Existing Products

```bash
curl -s -X PUT "https://api.printify.com/v1/shops/{SHOP_ID}/products/{PRODUCT_ID}.json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"tags": ["tag1", "tag2", ...], "title": "New Title"}'
```

After updating, republish to sync changes to Etsy.

---

## Batch Product Creation

For creating multiple products at once, use a Python script pattern:

```python
import json, subprocess, time

SHOP = "YOUR_SHOP_ID"

def read_token():
    with open("project/.env") as f:
        for line in f:
            if line.startswith("PRINTIFY_API_TOKEN="):
                return line.strip().split("=", 1)[1]

TOKEN = read_token()

def curl_post(url, data):
    result = subprocess.run(
        ["curl", "-s", "-X", "POST", url,
         "-H", f"Authorization: Bearer {TOKEN}",
         "-H", "Content-Type: application/json",
         "-d", json.dumps(data)],
        capture_output=True, text=True, timeout=30
    )
    return json.loads(result.stdout) if result.stdout.strip() else {}

# Define products — use your discovered blueprint/variant/price configuration
products = [
    {
        "title": "...",
        "image_url": "...",
        "tags": [...],  # 13 tags — NEVER omit!
        "blueprint_id": YOUR_BLUEPRINT,
        "provider_id": YOUR_PROVIDER,
        "variants": [{"id": VID, "price": PRICE_CENTS, "is_enabled": True}],
    },
    # ...
]

for p in products:
    # 1. Upload image
    img = curl_post("https://api.printify.com/v1/uploads/images.json",
                    {"file_name": "design.png", "url": p["image_url"]})
    image_id = img["id"]
    
    # 2. Create product (with tags!)
    product = curl_post(f"https://api.printify.com/v1/shops/{SHOP}/products.json", {
        "title": p["title"],
        "blueprint_id": p["blueprint_id"],
        "print_provider_id": p["provider_id"],
        "variants": p["variants"],
        "print_areas": [{"variant_ids": [v["id"] for v in p["variants"]],
                         "placeholders": [{"position": "front",
                                          "images": [{"id": image_id, "x": 0.5, "y": 0.5, "scale": 1, "angle": 0}]}]}],
        "tags": p["tags"],
    })
    
    # 3. Publish
    curl_post(f"https://api.printify.com/v1/shops/{SHOP}/products/{product['id']}/publish.json",
              {"title":True,"description":True,"images":True,"variants":True,"tags":True})
    
    time.sleep(1)  # Rate limiting
```

---

## Lifestyle Photo Upload (JS Injection)

Printify's `images` field only accepts auto-generated mockup references. To add custom lifestyle photos to listings that have few auto-mockups, upload them directly through Etsy's listing editor using JavaScript injection via browser automation.

### When to Use This
- Mug listings (Printify often generates only 1 mockup)
- Any product type where Printify generates fewer than 3 mockups
- To add lifestyle/context photos that show the product in a real setting

### The JS Injection Script

Navigate to `https://www.etsy.com/your/shops/{SHOP_NAME}/tools/listings/{ETSY_LISTING_ID}`, wait 15-20 seconds for the page to load, then run in the browser console:

```javascript
(async()=>{
  const r = await fetch('IMAGE_URL');
  const b = await r.blob();
  const f = new File([b], 'lifestyle.png', {type: 'image/png'});
  const dt = new DataTransfer();
  dt.items.add(f);
  const inputs = document.querySelectorAll('input[name="listing-media-upload"]');
  for (const i of inputs) {
    if (!i.files || i.files.length === 0) {
      Object.defineProperty(i, 'files', {value: dt.files, writable: true});
      i.files = dt.files;
      i.dispatchEvent(new Event('change', {bubbles: true}));
      break;
    }
  }
  return 'ok';
})()
```

After injection, wait 10-15 seconds for processing, then click "Publish changes."

**Important:** The Etsy listing editor is a heavy page. Always wait 15-20 seconds after navigation before attempting any interaction. Process 1-3 listings per browser session to avoid timeouts.

---

## Useful API Endpoints

| Endpoint | Method | Purpose |
|---|---|---|
| `/v1/shops.json` | GET | List all shops |
| `/v1/catalog/blueprints.json` | GET | List all product types |
| `/v1/catalog/blueprints/{id}/print_providers.json` | GET | List providers for a product |
| `/v1/catalog/blueprints/{id}/print_providers/{pid}/variants.json` | GET | Get variants & sizes |
| `/v1/catalog/blueprints/{id}/print_providers/{pid}/shipping.json` | GET | Get shipping costs |
| `/v1/uploads/images.json` | POST | Upload an image |
| `/v1/shops/{id}/products.json?page=N` | GET | List products (paginated) |
| `/v1/shops/{id}/products/{pid}.json` | GET | Get single product |
| `/v1/shops/{id}/products/{pid}.json` | PUT | Update product |
| `/v1/shops/{id}/products/{pid}/publish.json` | POST | Publish to Etsy |
| `/v1/shops/{id}/orders.json` | GET | List orders |

### Rate Limits
- Catalog endpoints: ~100 requests/minute
- Product endpoints: more generous but still throttle at high volume
- Add `time.sleep(1)` between batches of 10-15 requests
