# HTML to PowerPoint Guide

Convert HTML slides to PowerPoint with accurate positioning via the `html2pptx.js` library.

Three sections: **Creating HTML Slides** · **Using the html2pptx Library** · **Using PptxGenJS** (for charts/tables/dynamic content).

---

## Creating HTML Slides

### Body Sizing (mandatory — copy this template)

Use this exact body block for every slide (16:9 shown; for 4:3 use `540pt`, for 16:10 use `450pt` height):

```css
html, body { margin: 0; padding: 0; }
body {
  width: 720pt; height: 405pt;     /* MUST be on <body>, not on a wrapper */
  box-sizing: border-box;
  padding: 24pt 40pt 48pt 40pt;    /* bottom 48pt ≈ 0.67" clears the 0.5" text-margin rule */
  display: flex; flex-direction: column;   /* prevents margin collapse */
  overflow: hidden;                /* body-level fail-safe; text clipping still fails build */
}
```

### Container Layout Cheatsheet (avoid grid/flex overflow)

`html2pptx` rejects any body overflow. Grid/flex children do **not** auto-shrink — use these patterns or content will push tracks past the body and force rebuild loops.

| Use case | Safe pattern | Common mistake | Why it overflows |
|---|---|---|---|
| Vertical sections (title / body / chart) | `display:flex; flex-direction:column;` on body; children use `flex: 1 1 0; min-height: 0;` | `flex: 1` without `min-height: 0` | Flex item's default min-size is `min-content`, not 0 — long text pushes past `1fr`. |
| Equal-height card grid (2–4 cols, variable text) | `display:grid; grid-template-columns: repeat(N, minmax(0, 1fr)); grid-auto-rows: minmax(0, 1fr);` | `grid-template-rows: 1fr 1fr` | Grid track minimum is `min-content`; the longest cell stretches the whole row. |
| Inside any grid/flex child (cards, cells) | Add `min-width: 0; min-height: 0;` on the child itself; keep text visible and resize/split if it does not fit | Only setting sizing/overflow on the parent | Children don't inherit min-size constraints — each one needs its own. |

Additional guards:
- **Use CSS variables for shared sizes** (`--title-fs`, `--gap`) so one edit rebalances the whole deck.
- **Do not use `overflow:hidden` to hide text that does not fit**. It is allowed as a body/layout guard only when nothing is actually clipped; clipped text fails build because PPTX text boxes are laid out again by PowerPoint/WPS.
- **Fix systemically, not page-by-page** — when one slide overflows due to a recurring pattern, apply the same fix to all slides built from that pattern in one pass.

### Supported Elements

- `<p>`, `<h1>`–`<h6>` — text with styling
- `<ul>`, `<ol>` — lists (never use manual bullets •, -, *)
- `<b>` / `<strong>`, `<i>` / `<em>`, `<u>` — inline formatting
- `<span>` — inline formatting via CSS (bold, italic, underline, color)
- `<br>` — line breaks
- `<div>` — shape container ONLY (background/border/shadow). Must NOT contain raw text — wrap every text node in `<p>`/`<h*>`/`<li>` inside.
- `<img>` — images
- `class="placeholder"` — reserved space for tables/charts (returns `{ id, x, y, w, h }`)

### Unsupported Elements (silent data loss — no build error)

`<table>` / `<tr>` / `<td>`, `<svg>`, `<canvas>`, `<iframe>`, `<video>`, `<audio>` render in a browser but get dropped from the PPTX.

Two ways to render a table:
1. **Native PowerPoint table (recommended for data-heavy)** — `class="placeholder"` div + `slide.addTable(...)` in `build.js`
2. **Div-grid mock-up (visual-only)** — rebuild the grid with nested `<div>`s, each cell wraps text in `<p>`

### Critical Text Rules (BUILD ERROR if violated)

Four INDEPENDENT rules — breaking any one fails the build:

1. **All text must be wrapped in `<p>`, `<h1>`–`<h6>`, or `<li>`** — even a single word, digit, or label.
   `<div>` is a SHAPE container, never a text container. Raw text inside `<div>` triggers:
   `DIV element contains unwrapped text "...". All text must be wrapped in <p>, <h1>-<h6>, <ul>, or <ol> tags to appear in PowerPoint.`
2. **Box styling (`background`, `border`, `border-radius`, `box-shadow`) goes on `<div>` only** — never on `<p>`/`<h*>`/`<ul>`/`<ol>`/inline tags.
3. **`margin` is forbidden on inline tags** (`<b>`, `<i>`, `<u>`, `<span>`) — PowerPoint text runs ignore it. Use a space, `&nbsp;`, or padding on the parent block.
4. **Never use manual bullet symbols** (•, -, *) — use `<ul>`/`<ol>`.

Rules are independent. A plain `<div>foo</div>` with no styling still fails rule 1 alone. When one slide hits any of these, **grep all sibling slides for the same pattern** and fix in one batch before rebuilding.

**Per-element quick reference** (what each element type accepts):

| Element | Box styling (`background` / `border` / `border-radius` / `box-shadow`) | `margin` | Inline formatting (`font-weight`, `color`, …) | Raw text child |
|---|---|---|---|---|
| `<div>` (shape) | ✅ becomes a shape | ✅ | — | ❌ wrap in `<p>`/`<h*>`/`<li>` |
| `<p>` / `<h1>`–`<h6>` / `<ul>` / `<ol>` (text block) | ❌ wrap in a styled `<div>` | ✅ | ✅ | ✅ |
| `<b>` / `<i>` / `<u>` / `<span>` (inline) | ❌ | ❌ | ✅ | ✅ |

**Examples** (matched to the rule numbers above):

| Scenario | ✅ Correct | ❌ Wrong | Violates |
|---|---|---|---|
| Plain text | `<p>Hello</p>` | `<div>Hello</div>` | Rule 1 |
| Single digit / badge / label | `<div class="badge"><p>5</p></div>` | `<div class="badge">5</div>` | Rule 1 |
| Styled card around text | `<div style="background:#eee;"><p>Hello</p></div>` | `<p style="background:#eee;">Hello</p>` | Rule 2 |
| Spacing after inline emphasis | `<p>Label: <b>42</b>&nbsp;&nbsp;units</p>` | `<p>Label: <b style="margin-right:8pt;">42</b> units</p>` | Rule 3 |
| Bulleted list | `<ul><li>Item</li></ul>` | `<p>• Item</p>` | Rule 4 |

**Supported `<div>` styling** (rule 2's ✅ column, in detail):
- **Backgrounds**: `background` / `background-color` → shape fill. e.g. `<div style="background: #f0f0f0;">`
- **Borders**: uniform (`border: 2px solid #333`) → shape border; partial (`border-left/right/top/bottom`) → line shapes. e.g. `<div style="border-left: 8pt solid #E76F51;">`
- **Border radius**: `border-radius` (px/pt/%) → rounded corners. `≥50%` → circular. `<50%` is relative to the shape's smaller dimension (e.g. 25% on a 100×200 box = 25px). e.g. `border-radius: 8pt;`
- **Box shadows**: outer shadows only (insets are silently skipped to avoid corruption). e.g. `<div style="box-shadow: 2px 2px 8px rgba(0,0,0,0.3);">`

### Other Text Constraints

- **ONLY web-safe fonts**: `Arial`, `Helvetica`, `Times New Roman`, `Georgia`, `Courier New`, `Verdana`, `Tahoma`, `Trebuchet MS`, `Impact`, `Comic Sans MS`. Custom fonts (`Segoe UI`, `SF Pro`, `Roboto`, etc.) may cause rendering issues.
- **NEVER rely on CSS clipping for text**: if a text element or one of its overflow-clipping ancestors actually cuts off text (`overflow:hidden`, `clip`, `auto`, or `scroll`), `html2pptx` fails the build. Enlarge the box, reduce text, reduce font size, or split the slide.

### Styling

- `margin` for spacing (padding is part of size). Flexbox positions are computed from rendered layout.
- Hex colors with `#` prefix in CSS (PptxGenJS API uses no `#` — see [Critical Rules](#-critical-rules)).
- **Text alignment**: CSS `text-align` (`center`, `right`, …) hints PptxGenJS formatting when text length varies slightly.

### Icons & Gradients

**CRITICAL: Never use CSS gradients (`linear-gradient`, `radial-gradient`)** — they don't convert to PowerPoint. Pre-rasterize all gradients and icons to PNG **before** HTML rendering, then reference the PNG.

Runtime icon and SVG rasterization uses `scripts/rasterize.js`, which combines the pre-extracted `scripts/icons.js` data with browser Canvas via the bundled `scripts/cdp-browser.js`. Do **not** `require('sharp')`, `react`, `react-dom`, or `react-icons` in build scripts; those packages are not bundled at runtime.

**Available icon families** — `icons.js` currently contains these 5 families from `react-icons`; use the original export names (for example `FaHouse`, `MdSearch`, `LuCircle`, `AiOutlineHome`, `IoSearchOutline`):

| Prefix | Library |
|---|---|
| `Fa...` | Font Awesome 6 |
| `Md...` | Material Design |
| `Lu...` | Lucide |
| `Ai...` | Ant Design Icons |
| `Io...` | Ionicons 5 |

**Rasterizing Icons with the bundled Canvas path:**

```javascript
const { launch } = require('./cdp-browser');
const { findChromium } = require('./chromium-finder');
const { iconPng, listIcons } = require('./rasterize');

async function createAssets() {
  const found = findChromium();
  if (!found.executablePath) throw new Error('Install Chrome, Edge, or Brave');

  const browser = await launch({ executablePath: found.executablePath });
  try {
    // Optional: inspect available names, e.g. listIcons('Fa').slice(0, 20)
    await iconPng(browser, 'FaHouse', '4472c4', 256, 'home-icon.png');
  } finally {
    await browser.close();
  }
}

await createAssets();
// Then reference in HTML: <img src="home-icon.png" style="width: 40pt; height: 40pt;">
```

**Rasterizing Gradients with the bundled Canvas path:**

```javascript
const { launch } = require('./cdp-browser');
const { findChromium } = require('./chromium-finder');
const { gradientPng } = require('./rasterize');

async function createGradientBackground(filename) {
  const svg = `<svg xmlns="http://www.w3.org/2000/svg" width="1000" height="562.5">
    <defs>
      <linearGradient id="g" x1="0%" y1="0%" x2="100%" y2="100%">
        <stop offset="0%" style="stop-color:#COLOR1"/>
        <stop offset="100%" style="stop-color:#COLOR2"/>
      </linearGradient>
    </defs>
    <rect width="100%" height="100%" fill="url(#g)"/>
  </svg>`;

  const found = findChromium();
  if (!found.executablePath) throw new Error('Install Chrome, Edge, or Brave');

  const browser = await launch({ executablePath: found.executablePath });
  try {
    await gradientPng(browser, svg, filename, 1000, 563);
  } finally {
    await browser.close();
  }

  return filename;
}

// Usage: Create gradient background before HTML
const bgPath = await createGradientBackground("gradient-bg.png");
// Then in HTML: <body style="background-image: url('gradient-bg.png');">
```

### Charts & Tables: Reserve Space with a Placeholder

- **Charts and tables are NOT written in HTML** — leave a `<div id="..." class="placeholder">` for them and fill it in `build.js` via `slide.addChart(...)` / `slide.addTable(...)` at the returned placeholder position.
- Both `id` and `class="placeholder"` (so html2pptx captures the region and strips its descriptive label) are required — without the class the chart silently falls back to PptxGenJS default coordinates.

### Example

```html
<!DOCTYPE html>
<html>
<head>
<style>
html, body { margin: 0; padding: 0; }
body {
  width: 720pt; height: 405pt;
  box-sizing: border-box;
  padding: 24pt 40pt 48pt 40pt;
  display: flex; flex-direction: column;
  overflow: hidden;  /* body-level guard only; clipped text fails build */
  background: #f5f5f5; font-family: Arial, sans-serif;
}
.content { margin: 30pt; padding: 40pt; background: #ffffff; border-radius: 8pt; }
h1 { color: #2d3748; font-size: 32pt; }
.box {
  background: #70ad47; padding: 20pt; border: 3px solid #5a8f37;
  border-radius: 12pt; box-shadow: 3px 3px 10px rgba(0, 0, 0, 0.25);
}
</style>
</head>
<body>
<div class="content">
  <h1>Recipe Title</h1>
  <ul>
    <li><b>Item:</b> Description</li>
  </ul>
  <p>Text with <b>bold</b>, <i>italic</i>, <u>underline</u>.</p>
  <!-- Faint background + label so HTML-screenshot shows it as a reserved area, not a blank gap. -->
  <!-- BOTH `id` AND `class="placeholder"` are required. -->
  <div id="chart" class="placeholder"
       style="width: 350pt; height: 200pt; background: #f3f4f6; border: 1pt dashed #cbd5e1;
              display: flex; align-items: center; justify-content: center; color: #94a3b8;">
    <p style="font-size: 10pt;">[Chart placeholder]</p>
  </div>

  <!-- Even a single digit MUST be wrapped — <div class="box">5</div> would fail the build -->
  <div class="box">
    <p>5</p>
  </div>
</div>
</body>
</html>
```

## Using the html2pptx Library

### API Reference

```javascript
await html2pptx(htmlFile, pres, options)
```

**Parameters**:
- `htmlFile` (string) — path to HTML (absolute or relative)
- `pres` (pptxgen) — PptxGenJS instance with layout already set
- `options` (object, optional):
  - `tmpDir` (string) — temp dir for generated files (default `process.env.TMPDIR || '/tmp'`)
  - `slide` (object) — existing slide to reuse (default: creates new)

**Returns**:
```javascript
{
  slide: pptxgenSlide,
  placeholders: [
    { id: string, x: number, y: number, w: number, h: number },
    ...
  ]
}
```

### Validation

The library collects ALL errors before throwing — fix them in **one batch of edits** before re-running:

1. HTML dimensions must match the presentation layout
2. Content must not overflow body (reports exact measurements)
3. CSS gradients are flagged
4. Backgrounds/borders/shadows on text elements are flagged (allowed only on divs)

### Working with Placeholders

```javascript
const { slide, placeholders } = await html2pptx('slide.html', pptx);

slide.addChart(pptx.charts.BAR, data, placeholders[0]);          // by index
const chartArea = placeholders.find(p => p.id === 'chart-area'); // by ID
slide.addChart(pptx.charts.LINE, data, chartArea);
slide.addTable(rows, placeholders[1]);                            // tables: same pattern
```

### Complete Example

Two rules — non-negotiable:

1. **Batch validate**: wrap each slide in `try...catch`, collect all errors, throw once. Avoids the build → fix-1 → build → fix-2 loop.
2. **Always release Chromium** via `.finally(() => html2pptx.close())` — otherwise `writeFile()` errors hang the build until killed.

This is the canonical build script. Slide-specific chart/table additions go **inside the loop**, right after `html2pptx()` returns placeholders (gate by file name as needed).

```javascript
const pptxgen = require('pptxgenjs');
const html2pptx = require('./html2pptx');

async function main() {
  const pptx = new pptxgen();
  pptx.layout = 'LAYOUT_16x9';  // Must match HTML body dimensions
  pptx.author = 'Your Name';
  pptx.title = 'My Presentation';

  const slides = ['slides/title.html', 'slides/data.html'];

  const failures = [];
  for (const file of slides) {
    try {
      const { slide, placeholders } = await html2pptx(file, pptx);

      // Slide-specific dynamic content gated by file name.
      if (file === 'slides/data.html') {
        const chartData = [{
          name: 'Sales',
          labels: ['Q1', 'Q2', 'Q3', 'Q4'],
          values: [4500, 5500, 6200, 7100]
        }];
        slide.addChart(pptx.charts.BAR, chartData, {
          ...placeholders[0],
          showTitle: true, title: 'Quarterly Sales',
          showCatAxisTitle: true, catAxisTitle: 'Quarter',
          showValAxisTitle: true, valAxisTitle: 'Sales ($000s)'
        });

        // Native table in the second placeholder
        const tableRows = [
          [{ text: 'Quarter', options: { bold: true } }, { text: 'Sales', options: { bold: true } }],
          ['Q1', '4500'], ['Q2', '5500'], ['Q3', '6200'], ['Q4', '7100']
        ];
        slide.addTable(tableRows, { ...placeholders[1], fontSize: 10, border: { type: 'solid', pt: 0.5 } });
      }
    } catch (err) {
      failures.push(`[${file}] ${err.message}`);
    }
  }

  if (failures.length) {
    throw new Error(
      `BUILD FAILED — ${failures.length}/${slides.length} slide(s) invalid:\n${failures.join('\n')}`
    );
  }

  await pptx.writeFile({ fileName: 'output.pptx' });
  console.log(`Built ${slides.length} slide(s).`);
}

main()
  .catch(err => { console.error(err.message || err); process.exitCode = 1; })
  .finally(() => html2pptx.close());   // ALWAYS release the shared Chromium
```

> If you don't need dynamic charts/tables, omit the `if (file === ...)` block — `html2pptx()` alone produces a complete slide from the HTML.

## Using PptxGenJS

After converting HTML to slides with `html2pptx`, you'll use PptxGenJS to add dynamic content like tables, charts, images, and additional elements.

### ⚠️ Critical Rules

#### Colors
- **NEVER use `#` prefix** with hex colors in PptxGenJS - causes file corruption
- ✅ Correct: `color: "FF0000"`, `fill: { color: "0066CC" }`
- ❌ Wrong: `color: "#FF0000"` (breaks document)

### Adding Images

Always calculate aspect ratios from actual image dimensions:

```javascript
// Get image dimensions: identify image.png | grep -o '[0-9]* x [0-9]*'
const imgWidth = 1860, imgHeight = 1519;  // From actual file
const aspectRatio = imgWidth / imgHeight;

const h = 3;  // Max height
const w = h * aspectRatio;
const x = (10 - w) / 2;  // Center on 16:9 slide

slide.addImage({ path: "chart.png", x, y: 1.5, w, h });
```

### Adding Text

```javascript
// Rich text with formatting
slide.addText([
    { text: "Bold ", options: { bold: true } },
    { text: "Italic ", options: { italic: true } },
    { text: "Normal" }
], {
    x: 1, y: 2, w: 8, h: 1
});
```

### Adding Shapes

```javascript
// Rectangle
slide.addShape(pptx.shapes.RECTANGLE, {
    x: 1, y: 1, w: 3, h: 2,
    fill: { color: "4472C4" },
    line: { color: "000000", width: 2 }
});

// Circle
slide.addShape(pptx.shapes.OVAL, {
    x: 5, y: 1, w: 2, h: 2,
    fill: { color: "ED7D31" }
});

// Rounded rectangle
slide.addShape(pptx.shapes.ROUNDED_RECTANGLE, {
    x: 1, y: 4, w: 3, h: 1.5,
    fill: { color: "70AD47" },
    rectRadius: 0.2
});
```

### Adding Charts

**Required for most charts**: axis labels via `catAxisTitle` (category) and `valAxisTitle` (value).

**Data format**: pass an array of series; each series is `{ name, labels, values }`. Labels define the X-axis. Each series → one legend entry. Use a single series for simple bar/line charts.

**Time Series — choose correct granularity** (charts with only 1 point usually mean wrong aggregation):
- **< 30 days**: daily (e.g., "10-01", "10-02")
- **30–365 days**: monthly (e.g., "2024-01")
- **> 365 days**: yearly (e.g., "2024")

**Chart colors**: align with your design palette, with strong inter-series contrast, readability against slide background, and accessibility (avoid red-green only). Pass via `chartColors` (no `#` prefix).

#### Bar Chart (single-series with full options)

```javascript
const { slide, placeholders } = await html2pptx('slide.html', pptx);

slide.addChart(pptx.charts.BAR, [{
    name: "Sales 2024",
    labels: ["Q1", "Q2", "Q3", "Q4"],
    values: [4500, 5500, 6200, 7100]
}], {
    ...placeholders[0],  // placeholder position
    barDir: 'col',       // 'col' = vertical, 'bar' = horizontal
    showTitle: true, title: 'Quarterly Sales',
    showLegend: false,   // not needed for single series
    // Axis labels (required)
    showCatAxisTitle: true, catAxisTitle: 'Quarter',
    showValAxisTitle: true, valAxisTitle: 'Sales ($000s)',
    // Axis scaling — for clustered data (e.g. 4500-7100) start min closer to min value
    valAxisMinVal: 0, valAxisMaxVal: 8000,
    valAxisMajorUnit: 2000,    // y-label spacing
    catAxisLabelRotate: 45,    // rotate if crowded
    dataLabelPosition: 'outEnd',
    dataLabelColor: '000000',
    chartColors: ["4472C4"]    // single color for single-series
});
```

#### Line Chart

```javascript
const chartArea = placeholders.find(p => p.id === 'chart-trend');  // placeholder by ID

slide.addChart(pptx.charts.LINE, [{
    name: "Temperature",
    labels: ["Jan", "Feb", "Mar", "Apr"],
    values: [32, 35, 42, 55]
}], {
    ...chartArea,
    lineSize: 4, lineSmooth: true,
    showCatAxisTitle: true, catAxisTitle: 'Month',
    showValAxisTitle: true, valAxisTitle: 'Temperature (°F)',
    valAxisMinVal: 0, valAxisMaxVal: 60, valAxisMajorUnit: 20,
    // For data clustered in a range (e.g. 32-55), prefer valAxisMinVal closer to min to show variation
    chartColors: ["4472C4", "ED7D31", "A5A5A5"]
});
```

#### Pie Chart (no axis labels)

**Single series only** — all categories in `labels`, values in `values`.

```javascript
slide.addChart(pptx.charts.PIE, [{
    name: "Market Share",
    labels: ["Product A", "Product B", "Other"],
    values: [35, 45, 20]
}], {
    ...placeholders[0],  // placeholder position
    showPercent: true, showLegend: true, legendPos: 'r',
    chartColors: ["4472C4", "ED7D31", "A5A5A5"]
});
```

#### Scatter Chart (unusual data format)

**First series = X values; subsequent series = Y values only**:

```javascript
const data1 = [{ x: 10, y: 20 }, { x: 15, y: 25 }, { x: 20, y: 30 }];
const data2 = [{ x: 12, y: 18 }, { x: 18, y: 22 }];
const allXValues = [...data1.map(d => d.x), ...data2.map(d => d.x)];

slide.addChart(pptx.charts.SCATTER, [
    { name: 'X-Axis', values: allXValues },              // X values
    { name: 'Series 1', values: data1.map(d => d.y) },   // Y values
    { name: 'Series 2', values: data2.map(d => d.y) }
], {
    ...placeholders.find(p => p.id === 'chart-scatter'),  // placeholder by ID
    lineSize: 0,                  // 0 = no connecting lines
    lineDataSymbol: 'circle', lineDataSymbolSize: 6,
    showCatAxisTitle: true, catAxisTitle: 'X Axis',
    showValAxisTitle: true, valAxisTitle: 'Y Axis',
    chartColors: ["4472C4", "ED7D31"]
});
```

#### Multiple Data Series

Pass multiple series objects — one color per series in `chartColors`.

```javascript
slide.addChart(pptx.charts.LINE, [
    { name: "Product A", labels: ["Q1", "Q2", "Q3", "Q4"], values: [10, 20, 30, 40] },
    { name: "Product B", labels: ["Q1", "Q2", "Q3", "Q4"], values: [15, 25, 20, 35] }
], {
    ...placeholders[0],  // placeholder position
    showCatAxisTitle: true, catAxisTitle: 'Quarter',
    showValAxisTitle: true, valAxisTitle: 'Revenue ($M)',
    chartColors: ["16A085", "FF6B9D"]   // one color per series
});
```

### Adding Tables

**Common table options**: `x, y, w, h` (position/size in inches) · `colW` / `rowH` (arrays in inches) · `border: { pt, color }` · `fill: { color }` (no `#`) · `align: "left"|"center"|"right"` · `valign: "top"|"middle"|"bottom"` · `fontSize` · `autoPage` (auto-create slides on overflow).

#### Basic Table

```javascript
slide.addTable([
    ["Header 1", "Header 2", "Header 3"],
    ["Row 1, Col 1", "Row 1, Col 2", "Row 1, Col 3"],
    ["Row 2, Col 1", "Row 2, Col 2", "Row 2, Col 3"]
], {
    ...placeholders[0],  // placeholder position
    border: { pt: 1, color: "999999" },
    fill: { color: "F1F1F1" }
});
```

#### Table with Custom Formatting (per-cell styles via `{ text, options }`)

```javascript
const tableData = [
    // Header row with custom styling
    [
        { text: "Product", options: { fill: { color: "4472C4" }, color: "FFFFFF", bold: true } },
        { text: "Revenue", options: { fill: { color: "4472C4" }, color: "FFFFFF", bold: true } },
        { text: "Growth",  options: { fill: { color: "4472C4" }, color: "FFFFFF", bold: true } }
    ],
    ["Product A", "$50M", "+15%"],
    ["Product B", "$35M", "+22%"],
    ["Product C", "$28M", "+8%"]
];

const tableArea = placeholders.find(p => p.id === 'table-products');  // placeholder by ID

slide.addTable(tableData, {
    ...tableArea,
    // Hardcoded colW/rowH override the placeholder's w/h — their totals MUST NOT
    // exceed tableArea.w / tableArea.h, or the table overflows the reserved space.
    colW: [3, 2.5, 2.5],
    rowH: [0.5, 0.6, 0.6, 0.6],
    border: { pt: 1, color: "CCCCCC" },
    align: "center", valign: "middle",
    fontSize: 14
});
```

#### Table with Merged Cells (`colspan` / `rowspan`)

```javascript
const mergedTableData = [
    [
        { text: "Q1 Results", options: { colspan: 3, fill: { color: "4472C4" }, color: "FFFFFF", bold: true } }
    ],
    ["Product", "Sales", "Market Share"],
    ["Product A", "$25M", "35%"],
    ["Product B", "$18M", "25%"]
];

slide.addTable(mergedTableData, {
    ...placeholders[1],  // placeholder position
    // colW total MUST NOT exceed the placeholder width (placeholders[1].w),
    // otherwise the table silently overflows into neighboring content.
    colW: [3, 2.5, 2.5],
    border: { pt: 1, color: "DDDDDD" }
});
```
