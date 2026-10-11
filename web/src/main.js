import { Buddy, Stage } from './domain/buddy.js';
import { attr, fetchXml } from './domain/catalog.js';
import { loadLanguage, t } from './domain/i18n.js';
import { keepPosing, startPosing } from './domain/poses.js';
import { TextureLibrary } from './domain/textures.js';
import { Wardrobe } from './domain/wardrobe.js';
import { renderActions } from './ui/action-grid.js';
import { renderWardrobe } from './ui/wardrobe-panel.js';

const STORAGE_KEY = 'buddyrevival';
const FRIEND_LOOK = { hdc: 9, bdc: 9, hrt: 25, hrc: 180, eyc: 13, shc: 120, sl1t: 0, sl2t: 0, plc: 1, sst: 5, ssc: 2 };
const EXAMINE_CAMERA = 'Camera_Long2';
const ROOT_NODE = 'IG_Root';

const $ = id => document.getElementById(id);
const canvas = $('stage');
const g = canvas.getContext('2d');
const { width, height } = canvas;

await loadLanguage();
const labels = {
  'tab-wardrobe': 'Customize Appearance', 'tab-moods': 'Change Mood', 'tab-pokes': 'Poke a Friend',
  'label-me': 'You', 'label-friend': 'Friend', 'reset': 'Default', 'randomize': 'Random',
  'label-code': 'Buddy code', 'copy': 'Copy', 'apply': 'Apply',
};
for (const [id, text] of Object.entries(labels)) $(id).textContent = t(text);

const bytes = async url => new Uint8Array(await (await fetch(url)).arrayBuffer());
const text = async url => (await fetch(url)).text();
const [textures, chick, setting, catalog, wardrobe, moodList, pokeList] = await Promise.all([
  TextureLibrary.load('assets/chick/'),
  bytes('assets/chick.bin'),
  bytes('assets/setting.bin'),
  text('assets/chick/catalog.xml'),
  Wardrobe.load('assets/wardrobe.xml'),
  fetchXml('assets/moods.xml'),
  fetchXml('assets/pokes.xml'),
]);

const moods = [...moodList.children].map(mood => ({
  name: attr(mood, 'name'),
  icon: attr(mood, 'icon'),
  caption: attr(mood, 'desc'),
  animation: attr(mood, 'a0'),
}));
const pokes = [...pokeList.children].map(poke => ({
  name: attr(poke, 'name'),
  icon: `anim_${attr(poke, 'a0').replace('1', '')}`,
  caption: attr(poke, 'hist'),
  animations: [attr(poke, 'a0'), attr(poke, 'a1')],
}));

const buddies = {
  me: await Buddy.load(chick, { width, height, textures, catalog }),
  friend: await Buddy.load(chick, { width, height, textures, catalog }),
};
const stage = await Stage.load(setting, { width, height });
stage.host(buddies.me, 'Buddy1');
stage.host(buddies.friend, 'Buddy2');

let saved = {};
try {
  saved = JSON.parse(localStorage.getItem(STORAGE_KEY)) ?? {};
} catch {}
await wardrobe.wearCode(buddies.me, new URLSearchParams(location.search).get('buddy') ?? saved.me);
if (saved.friend) await wardrobe.wearCode(buddies.friend, saved.friend);
else await wardrobe.wearOverDefault(buddies.friend, FRIEND_LOOK);
for (const buddy of Object.values(buddies)) startPosing(buddy);

let mode = 'wardrobe';
let editing = 'me';
let redrawWardrobe = () => {};
const caption = message => { $('caption').textContent = message; };

async function save(who) {
  saved[who] = await wardrobe.codeOf(buddies[who]);
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(saved));
  } catch {}
  if (who === editing) $('code').value = saved[who];
}

async function customize(who) {
  editing = who;
  mode = 'wardrobe';
  const buddy = buddies[who];
  buddy.camera = buddy.scene.node(EXAMINE_CAMERA);
  buddy.play('pose_contra');
  canvas.classList.add('examine');
  caption(t('click and drag your mouse to rotate'));
  $('code').value = saved[who] ?? await wardrobe.codeOf(buddy);
  redrawWardrobe = await renderWardrobe($('wardrobe'), wardrobe, buddy, () => save(who));
}

function showMood(mood) {
  mode = 'mood';
  buddies.me.camera = null;
  buddies.me.play(mood.animation, { loop: true });
  caption(t(mood.caption).replace('%', t('You')));
}

function showPoke(poke) {
  mode = 'poke';
  buddies.me.play(poke.animations[0], { loop: true });
  buddies.friend.play(poke.animations[1], { loop: true });
  caption(t(poke.caption).replace('%1', t('You')).replace('%2', t('Friend')));
}

const tabs = { wardrobe: 'tab-wardrobe', mood: 'tab-moods', poke: 'tab-pokes' };
async function selectTab(name) {
  for (const [key, id] of Object.entries(tabs)) {
    $(id).ariaSelected = key === name;
    $($(id).getAttribute('aria-controls')).hidden = key !== name;
  }
  canvas.classList.toggle('examine', name === 'wardrobe');
  if (name === 'wardrobe') await customize(editing);
  if (name === 'mood') $('moods').querySelector('button')?.click();
  if (name === 'poke') $('pokes').querySelector('button')?.click();
}
for (const [key, id] of Object.entries(tabs)) $(id).onclick = () => selectTab(key);

renderActions($('moods'), moods, showMood);
renderActions($('pokes'), pokes, showPoke);

const edit = async change => {
  await change(buddies[editing]);
  redrawWardrobe();
  save(editing);
};
for (const radio of document.querySelectorAll('input[name=who]')) radio.onchange = () => customize(radio.value);
$('reset').onclick = () => edit(buddy => wardrobe.wearCode(buddy, null));
$('randomize').onclick = () => edit(buddy => wardrobe.randomize(buddy));
$('apply').onclick = () => edit(buddy => wardrobe.wearCode(buddy, $('code').value.trim()));
$('copy').onclick = async () => {
  await navigator.clipboard.writeText($('code').value);
  $('copy').textContent = t('Copied!');
  setTimeout(() => { $('copy').textContent = t('Copy'); }, 1500);
};

let dragX = null;
canvas.onpointerdown = event => {
  if (mode !== 'wardrobe') return;
  const buddy = buddies[editing];
  buddy.camera.lookAt = buddy.scene.node(ROOT_NODE);
  buddy.camera.centerOffset = { x: 0, y: 14 * height / 260 };
  dragX = event.clientX;
  canvas.setPointerCapture(event.pointerId);
};
canvas.onpointerup = canvas.onpointercancel = () => { dragX = null; };
canvas.onpointermove = event => {
  if (dragX === null) return;
  const buddy = buddies[editing];
  const camera = buddy.camera;
  const eye = camera.worldPosition();
  const center = buddy.scene.node(ROOT_NODE).worldPosition();
  const angle = Math.atan2(eye.z - center.z, eye.x - center.x) + (event.clientX - dragX) / canvas.clientWidth * 2 * Math.PI;
  const distance = Math.hypot(eye.z - center.z, eye.x - center.x);
  dragX = event.clientX;
  camera.position.x = center.x + distance * Math.cos(angle);
  camera.position.z = center.z + distance * Math.sin(angle);
};

await customize('me');

(function frame() {
  g.clearRect(0, 0, width, height);
  if (mode === 'wardrobe') {
    keepPosing(buddies[editing]);
    buddies[editing].render(g);
  } else if (mode === 'mood') {
    buddies.me.step();
    buddies.me.render(g);
  } else {
    stage.render(g);
  }
  requestAnimationFrame(frame);
})();
