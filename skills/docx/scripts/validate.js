#!/usr/bin/env node
// Validate a .docx file by strict-parsing every XML part inside the OOXML zip.
// Uses jszip + sax, both pre-bundled in this skill's node_modules — zero extra deps.
//
// Usage:
//   node scripts/validate.js <file.docx>
// Exit codes:
//   0 = VALID, 1 = INVALID, 2 = usage error

const fs = require('fs');
const path = require('path');

// Resolve jszip/sax from this skill's node_modules even when caller's cwd differs.
const SKILL_NM = path.join(__dirname, '..', 'node_modules');
if (!process.env.NODE_PATH || !process.env.NODE_PATH.includes(SKILL_NM)) {
  require('module').Module._initPaths();
  process.env.NODE_PATH = SKILL_NM + path.delimiter + (process.env.NODE_PATH || '');
  require('module').Module._initPaths();
}
const JSZip = require('jszip');
const sax = require('sax');

const REQUIRED_PARTS = ['[Content_Types].xml', 'word/document.xml'];

async function validate(filePath) {
  const errors = [];
  if (!fs.existsSync(filePath)) {
    return { ok: false, errors: [`file not found: ${filePath}`] };
  }

  let zip;
  try {
    zip = await JSZip.loadAsync(fs.readFileSync(filePath));
  } catch (e) {
    return { ok: false, errors: [`not a valid zip/docx container: ${e.message}`] };
  }

  for (const p of REQUIRED_PARTS) {
    if (!zip.file(p)) errors.push(`missing required part: ${p}`);
  }

  for (const name of Object.keys(zip.files)) {
    if (zip.files[name].dir) continue;
    if (!/\.(xml|rels)$/i.test(name)) continue;
    const xml = await zip.file(name).async('string');
    try {
      await new Promise((resolve, reject) => {
        const parser = sax.parser(true); // strict
        parser.onerror = (e) => reject(e);
        parser.onend = resolve;
        parser.write(xml).close();
      });
    } catch (e) {
      const msg = String(e.message || e).split('\n')[0];
      errors.push(`${name}: ${msg}`);
    }
  }

  return { ok: errors.length === 0, errors };
}

(async () => {
  const file = process.argv[2];
  if (!file) {
    console.error('Usage: node scripts/validate.js <file.docx>');
    process.exit(2);
  }
  const { ok, errors } = await validate(file);
  if (ok) {
    console.log(`VALID: ${file}`);
    process.exit(0);
  }
  console.error(`INVALID: ${file}`);
  for (const e of errors) console.error(`  - ${e}`);
  process.exit(1);
})();
