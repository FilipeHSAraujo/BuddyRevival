import { fetchXml } from './catalog.js';

const LANGUAGES = ['pt', 'es', 'fr', 'th', 'zh'];

let messages = null;

export async function loadLanguage(language = navigator.language) {
  const code = (language ?? '').slice(0, 2);
  if (!LANGUAGES.includes(code)) return;
  const bundle = await fetchXml(`assets/i18n/${code}.xml`);
  messages = Object.create(null);
  for (const msg of bundle.getElementsByTagName('msg')) messages[msg.getAttribute('name')] = msg.textContent;
  document.documentElement.lang = code;
}

export function t(text, female = false) {
  if (!messages) return text;
  if (female && messages[`${text}(f)`]) return messages[`${text}(f)`];
  return messages[text] ?? messages[text.toLowerCase()] ?? text;
}
