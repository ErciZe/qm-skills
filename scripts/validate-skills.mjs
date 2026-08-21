import { lstat, readFile, readdir } from "node:fs/promises";
import { relative, resolve, sep } from "node:path";

const root = resolve(import.meta.dirname, "..");
const skillsRoot = resolve(root, "skills");
const secretPatterns = [
  /-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----/,
  /\bgh[pousr]_[A-Za-z0-9]{20,}\b/,
  /\bAKIA[0-9A-Z]{16}\b/,
];

async function filesUnder(directory) {
  const files = [];
  for (const entry of await readdir(directory, { withFileTypes: true })) {
    const absolute = resolve(directory, entry.name);
    const path = relative(root, absolute).split(sep).join("/");
    if (path.split("/").includes("..")) throw new Error(`unsafe path: ${path}`);
    if ((await lstat(absolute)).isSymbolicLink()) throw new Error(`symbolic links are not allowed: ${path}`);
    if (entry.isDirectory()) files.push(...(await filesUnder(absolute)));
    else if (entry.isFile()) files.push({ absolute, path });
  }
  return files;
}

function frontmatter(text, path) {
  const match = text.match(/^---\n([\s\S]*?)\n---\n([\s\S]+)$/);
  if (!match) throw new Error(`${path}: missing frontmatter or body`);
  const attrs = match[1];
  const name = attrs.match(/^name:\s*([^\n]+)$/m)?.[1]?.trim();
  const description = attrs.match(/^description:\s*([^\n]+)$/m)?.[1]?.trim();
  if (!name || !/^[a-z0-9][a-z0-9-]*$/.test(name)) throw new Error(`${path}: invalid name`);
  if (!description) throw new Error(`${path}: description is required`);
  if (!match[2].trim()) throw new Error(`${path}: body is required`);
  return name;
}

const files = await filesUnder(skillsRoot);
const skillFiles = files.filter(({ path }) => path.endsWith("/SKILL.md"));
if (!skillFiles.length) throw new Error("at least one SKILL.md is required");
const names = new Set();

for (const file of files) {
  const bytes = await readFile(file.absolute);
  if (bytes.includes(0)) throw new Error(`${file.path}: binary files are not allowed`);
  const text = bytes.toString("utf8");
  if (text.includes("\uFFFD")) throw new Error(`${file.path}: invalid UTF-8`);
  if (secretPatterns.some((pattern) => pattern.test(text))) throw new Error(`${file.path}: possible secret detected`);
  if (!file.path.endsWith("/SKILL.md")) continue;
  const name = frontmatter(text, file.path);
  if (names.has(name)) throw new Error(`${file.path}: duplicate skill name ${name}`);
  names.add(name);
}

process.stdout.write(`Validated ${names.size} skill${names.size === 1 ? "" : "s"}.\n`);
