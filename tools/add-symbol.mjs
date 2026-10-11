import { readFileSync, writeFileSync } from 'node:fs';
import { basename } from 'node:path';

const [name, ...files] = process.argv.slice(2);
const iconFlag = files.indexOf('--icon');
const icon = iconFlag === -1 ? null : files.splice(iconFlag, 2)[1];

if (!name || !files.length) {
  console.error('usage: node tools/add-symbol.mjs <SymbolName> <frame1.svg> [frame2.svg ...] [--icon icon.svg]');
  process.exit(1);
}

const library = new URL('../web/assets/chick/', import.meta.url);
const update = (file, change) => {
  const url = new URL(file, library);
  const data = JSON.parse(readFileSync(url, 'utf8'));
  change(data);
  writeFileSync(url, JSON.stringify(data));
};

update('symbols.json', symbols => {
  symbols[name] = files.map(f => readFileSync(f, 'utf8'));
});
if (icon) update('icons.json', icons => {
  icons[`Icon_${name}`] = readFileSync(icon, 'utf8');
});

console.log(`${name}: ${files.map(f => basename(f)).join(', ')}${icon ? ` + Icon_${name}` : ''}`);
