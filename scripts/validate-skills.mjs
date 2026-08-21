import { lstat, readFile, readdir } from "node:fs/promises";
import { relative, resolve, sep } from "node:path";

const root = resolve(import.meta.dirname, "..");
const skillsRoot = resolve(root, "skills");
const maxFileBytes = 256 * 1024;
const maxSkillBytes = 1024 * 1024;
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
  const attrs = new Map();
  for (const line of match[1].split("\n")) {
    const entry = line.match(/^([A-Za-z][A-Za-z0-9]*):\s*(.*)$/);
    if (!entry) throw new Error(`${path}: invalid frontmatter line`);
    if (attrs.has(entry[1])) throw new Error(`${path}: duplicate frontmatter field ${entry[1]}`);
    attrs.set(entry[1], entry[2].trim());
  }
  const name = attrs.get("name");
  const description = attrs.get("description");
  if (!name || !/^[a-z0-9][a-z0-9-]*$/.test(name)) throw new Error(`${path}: invalid name`);
  if (!description) throw new Error(`${path}: description is required`);
  if (attrs.get("scope") !== "company") throw new Error(`${path}: scope must be company`);
  if (attrs.has("category") && !attrs.get("category")) throw new Error(`${path}: category must not be empty`);
  const capabilities = attrs.get("requiredCapabilities");
  if (capabilities !== undefined && !/^\[[^\]\r\n]*\]$/.test(capabilities)) {
    throw new Error(`${path}: requiredCapabilities must be an inline list`);
  }
  if (!match[2].trim()) throw new Error(`${path}: body is required`);
  return name;
}

const files = await filesUnder(skillsRoot);
const skillFiles = files.filter(({ path }) => path.endsWith("/SKILL.md"));
if (!skillFiles.length) throw new Error("at least one SKILL.md is required");
const names = new Set();
const skillBytes = new Map();

for (const file of files) {
  const bytes = await readFile(file.absolute);
  if (bytes.byteLength > maxFileBytes) throw new Error(`${file.path}: file exceeds 256 KiB`);
  const skillDirectory = file.path.split("/").slice(0, 2).join("/");
  const totalBytes = (skillBytes.get(skillDirectory) ?? 0) + bytes.byteLength;
  if (totalBytes > maxSkillBytes) throw new Error(`${skillDirectory}: skill exceeds 1 MiB`);
  skillBytes.set(skillDirectory, totalBytes);
  if (bytes.includes(0)) throw new Error(`${file.path}: binary files are not allowed`);
  const text = bytes.toString("utf8");
  if (text.includes("\uFFFD")) throw new Error(`${file.path}: invalid UTF-8`);
  if (secretPatterns.some((pattern) => pattern.test(text))) throw new Error(`${file.path}: possible secret detected`);
  if (!file.path.endsWith("/SKILL.md")) continue;
  const name = frontmatter(text, file.path);
  const directoryName = file.path.split("/").at(-2);
  if (directoryName !== name) throw new Error(`${file.path}: directory must match skill name ${name}`);
  if (names.has(name)) throw new Error(`${file.path}: duplicate skill name ${name}`);
  names.add(name);
}

process.stdout.write(`Validated ${names.size} skill${names.size === 1 ? "" : "s"}.\n`);
