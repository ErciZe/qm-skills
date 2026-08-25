# Etsy SEO & Tag Generation Guide

## Why Tags Matter

Tags are the primary mechanism Etsy uses to match buyer search queries to listings. Without tags, a listing is invisible to search — regardless of title quality, photo count, or pricing. In testing, adding 13 tags to previously tagless listings was the single highest-impact SEO fix.

---

## Title Optimization

### The Mobile-First Formula
46%+ of Etsy sales happen on mobile. Titles are truncated, making the first 40 characters critical.

**Structure:** `Product Name: Key Descriptors, Use Case, Style`

**Rules:**
1. Front-load the highest-volume keyword in the first 40 characters
2. Use natural language — write for humans, not robots
3. Max 140 characters; use as much as possible without keyword stuffing
4. Don't repeat words already in your tags
5. Include the product type clearly (Art Print, Coffee Mug, Poster, Sticker)

**Examples:**
- `Mushroom Forest Wall Art Print: Dark Botanical Poster, Cottagecore Decor, Woodland Nursery`
- `Best Dad Ever Coffee Mug: Funny Father's Day Gift, Navy Gold Mustache, Office Cup`
- `March Daffodil Birth Flower Art Print: Spring Botanical Poster, Birthday Gift for Her`

---

## The 13-Tag Strategy ("3-8 Split")

Every listing needs exactly 13 tags. Use multi-word phrases only (never single words).

### Tag Categories

**3-4 Broad Tags** (high volume, high competition):
- Product type: "wall art print", "coffee mug gift", "home decor poster"
- General gift: "gift for her", "housewarming gift", "birthday present"

**3-4 Occasion/Gift Tags** (buyer intent):
- Holiday: "mothers day gift", "fathers day present", "easter decoration"
- Event: "graduation gift", "nurse appreciation gift", "teacher gift"
- Personal: "march birthday gift", "birth month flower", "zodiac gift"

**2-3 Style/Aesthetic Tags** (trend-aligned):
- "grandma core aesthetic", "cottagecore farmhouse", "boho chic decor"
- "dark moody botanical", "minimalist design", "art deco vintage"
- "japanese zen style", "dopamine decor colorful", "desert southwest boho"

**1-2 Room/Placement Tags** (specific use case):
- "bathroom wall decor", "kitchen wall art", "office desk decor"
- "nursery room art", "bedroom wall art", "living room decor"

**1 Trending Tag** (rotates with current trends):
- "trending home decor", "spring decor", "viral tiktok aesthetic"

**1 Product-Specific Tag** (long-tail, high conversion):
- "11oz white ceramic mug", "unframed poster print", "multiple sizes available"

---

## Tag Generation Algorithm

The Python function below generates 13 context-aware tags from a product title and product type. Integrate this into every product creation workflow. Customize the product type detection for your specific blueprints.

```python
import datetime

def generate_tags(title, product_type="poster"):
    """Generate 13 SEO-optimized tags for an Etsy listing.
    
    Args:
        title: Product title string
        product_type: "poster", "mug", "sticker", "tote", etc.
    Returns:
        List of 13 tag strings
    """
    is_mug = product_type in ("mug", "cup", "drinkware")
    is_sticker = product_type in ("sticker", "decal")
    title_lower = title.lower()
    current_year = datetime.datetime.now().year
    tags = []
    
    # === BROAD TAGS (3) ===
    if is_mug:
        tags.extend(["coffee mug gift", "ceramic coffee cup", "unique mug gift"])
    elif is_sticker:
        tags.extend(["vinyl sticker", "laptop sticker decal", "water bottle sticker"])
    else:
        tags.extend(["wall art print", "home decor poster", "art print gift"])
    
    # === OCCASION/GIFT TAGS (3) ===
    occasion_map = {
        "mother": ["mothers day gift", "gift for mom", "new mom present"],
        "mom": ["mothers day gift", "gift for mom", "new mom present"],
        "dad": ["fathers day gift", "gift for dad", "dad birthday present"],
        "father": ["fathers day gift", "gift for dad", "dad birthday present"],
        "nurse": ["nurse appreciation gift", "nurses week present", "medical humor"],
        "teacher": ["teacher appreciation gift", "end of year teacher", "classroom decor"],
        "graduation": [f"graduation gift {current_year}", "senior year present", "college dorm decor"],
        "class of": [f"graduation gift {current_year}", "senior year present", "college dorm decor"],
        "easter": ["easter decoration", "spring home decor", "easter hostess gift"],
        "valentine": ["valentines day gift", "love gift for her", "romantic present"],
        "christmas": ["christmas gift idea", "holiday home decor", "stocking stuffer"],
        "halloween": ["halloween decoration", "spooky gothic decor", "fall home accent"],
        "baby": ["baby shower gift", "new baby present", "nursery decor"],
        "wedding": ["wedding gift idea", "bridal shower present", "newlywed gift"],
    }
    matched_occasion = False
    for keyword, occ_tags in occasion_map.items():
        if keyword in title_lower:
            tags.extend(occ_tags)
            matched_occasion = True
            break
    
    # Birth flower special case
    if not matched_occasion and "birth flower" in title_lower:
        months = {
            "january": "january birthday gift", "february": "february birthday gift",
            "march": "march birthday gift", "april": "april birthday gift",
            "may": "may birthday gift", "june": "june birthday gift",
            "july": "july birthday gift", "august": "august birthday gift",
            "september": "september birthday gift", "october": "october birthday gift",
            "november": "november birthday gift", "december": "december birthday gift",
        }
        for month, tag in months.items():
            if month in title_lower:
                tags.extend([tag, "birth month flower", "personalized birthday"])
                matched_occasion = True
                break
    
    if not matched_occasion:
        tags.extend(["gift for her", "housewarming gift", "birthday present"])
    
    # === STYLE/AESTHETIC TAGS (2-3) ===
    style_map = {
        "grandma core": "grandma core aesthetic",
        "cottagecore": "cottagecore farmhouse",
        "cabbagecore": "cabbagecore trending",
        "boho": "boho chic decor",
        "zen": "zen minimalist style",
        "japanese": "japanese art style",
        "art deco": "art deco vintage",
        "botanical": "botanical illustration",
        "watercolor": "watercolor artwork",
        "minimalist": "minimalist design",
        "vintage": "vintage style decor",
        "coastal": "coastal beach decor",
        "dark botanical": "dark moody botanical",
        "mushroom": "mushroom cottagecore",
        "celestial": "celestial moon decor",
        "moon": "moon phases art",
        "floral": "floral garden art",
        "lace": "vintage lace pattern",
        "desert": "desert southwest boho",
        "sunflower": "sunflower garden art",
        "cherry blossom": "cherry blossom spring",
        "lavender": "lavender botanical art",
        "dopamine": "dopamine decor colorful",
        "retro": "retro vintage aesthetic",
        "gothic": "dark gothic aesthetic",
        "tropical": "tropical palm leaf",
    }
    for keyword, tag in style_map.items():
        if keyword in title_lower:
            tags.append(tag)
            if len(tags) >= 10:
                break
    
    # === ROOM/PLACEMENT TAG (1) ===
    room_map = {
        "bathroom": "bathroom wall decor",
        "bedroom": "bedroom wall art",
        "kitchen": "kitchen wall decor",
        "office": "office desk decor",
        "nursery": "nursery room art",
        "bar": "home bar wall decor",
        "cabin": "rustic cabin decor",
        "playroom": "kids playroom art",
        "dorm": "college dorm decor",
        "dining": "dining room wall art",
    }
    room_added = False
    for keyword, tag in room_map.items():
        if keyword in title_lower:
            tags.append(tag)
            room_added = True
            break
    if not room_added:
        if is_mug:
            tags.append("kitchen coffee bar decor")
        elif is_sticker:
            tags.append("laptop water bottle decor")
        else:
            tags.append("living room wall art")
    
    # === SEASONAL TAG (1, if applicable) ===
    if any(w in title_lower for w in ["spring", "cherry blossom", "sakura", "easter", "daffodil"]):
        tags.append(f"spring decor {current_year}")
    elif any(w in title_lower for w in ["autumn", "fall", "harvest", "pumpkin"]):
        tags.append("fall autumn decor")
    elif any(w in title_lower for w in ["summer", "beach", "tropical"]):
        tags.append("summer garden decor")
    elif any(w in title_lower for w in ["winter", "christmas", "snow"]):
        tags.append("winter holiday decor")
    
    # === PRODUCT-SPECIFIC TAG (1) ===
    product_tags = {
        "mug": "ceramic coffee mug 11oz",
        "cup": "ceramic coffee mug 11oz",
        "poster": "unframed poster print",
        "sticker": "waterproof vinyl sticker",
        "tote": "canvas tote bag",
    }
    tags.append(product_tags.get(product_type, "unique handmade gift"))
    
    # === TRENDING TAG (1) ===
    tags.append(f"trending home decor {current_year}")
    
    # === DEDUPLICATE AND PAD TO 13 ===
    seen = set()
    unique = []
    for t in tags:
        key = t.strip().lower()
        if key and key not in seen:
            seen.add(key)
            unique.append(t)
    
    padding_mug = [
        "cute coffee cup", "aesthetic mug", "coworker gift idea",
        "self care gift", "morning coffee mug", "funny mug gift",
        "tea cup ceramic", "desk accessories gift"
    ]
    padding_poster = [
        "aesthetic room decor", "gallery wall art", "apartment wall decor",
        "above bed art print", "modern wall hanging", "new home gift",
        "accent wall art", "boho wall print"
    ]
    padding_sticker = [
        "planner sticker", "journal sticker", "aesthetic sticker pack",
        "cute sticker gift", "phone case sticker", "scrapbook sticker",
        "kawaii sticker", "trendy sticker decal"
    ]
    if is_mug:
        padding = padding_mug
    elif is_sticker:
        padding = padding_sticker
    else:
        padding = padding_poster
    
    for p in padding:
        if len(unique) >= 13:
            break
        if p.lower() not in seen:
            unique.append(p)
            seen.add(p.lower())
    
    return unique[:13]
```

---

## Description Template

```html
<p><strong>{Product Name}</strong> — {1-2 sentence hook with emotional/benefit appeal}.</p>

<p><strong>What You'll Love:</strong></p>
<ul>
<li>{Key visual/design feature}</li>
<li>{Quality/material detail}</li>
<li>{Size options or capacity}</li>
<li>{Perfect for: room/occasion}</li>
</ul>

<p><strong>Product Details:</strong></p>
<ul>
<li>{Material specification}</li>
<li>{Dimensions/sizes available}</li>
<li>{Care instructions}</li>
<li>{Shipping info}</li>
</ul>

<p><strong>Makes a Perfect Gift For:</strong> {2-3 recipient types}</p>

<p>Designed with care by {YOUR_SHOP_NAME}. Follow our shop for new designs weekly!</p>
```

---

## Common Tag Mistakes to Avoid

1. **Single-word tags** — "botanical" won't match "botanical print" searches
2. **Repeating title words** — If "mushroom" is in the title, use "woodland fungi art" in tags
3. **Generic tags** — "gift" alone is useless; use "gift for plant lover" instead
4. **Too many broad tags** — You need the long-tail tags for actual ranking
5. **Forgetting tags entirely** — This is the #1 cause of zero search traffic on new shops
6. **Hardcoding year in tags** — Always use the current year dynamically (the algorithm above does this)
