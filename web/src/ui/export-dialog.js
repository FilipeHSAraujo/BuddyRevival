import { t } from '../domain/i18n.js';
import { canExportVideo, exportClip } from '../export/export-clip.js';

const FORMATS = [
  { value: 'mp4', label: 'Video (MP4)', hint: 'Instagram, TikTok, WhatsApp' },
  { value: 'gif', label: 'GIF', hint: 'Discord, X, WhatsApp' },
];
const ASPECTS = [
  { value: 'portrait', label: 'Vertical 9:16', hint: 'Reels, Stories, TikTok' },
  { value: 'square', label: 'Square 1:1', hint: 'Feed' },
  { value: 'landscape', label: 'Landscape 4:3', hint: 'Like the screen' },
];

const element = (tag, props = {}, ...children) => {
  const node = Object.assign(document.createElement(tag), props);
  node.append(...children);
  return node;
};

function radioGroup(name, legend, choices, selected) {
  return element('fieldset', {},
    element('legend', { textContent: t(legend) }),
    ...choices.map(choice => element('label', { className: 'choice' },
      element('input', { type: 'radio', name, value: choice.value, checked: choice.value === selected }),
      element('span', { textContent: t(choice.label) }),
      element('small', { textContent: t(choice.hint) }))));
}

/**
 * dialog: an empty <dialog>. getSource() returns the animation to export, or null.
 * pause(paused) stops and restarts the live preview while frames are being rendered.
 */
export function setupExportDialog(dialog, getSource, pause) {
  const formats = radioGroup('export-format', 'Format', FORMATS, 'mp4');
  const aspects = radioGroup('export-aspect', 'Shape', ASPECTS, 'portrait');
  const caption = element('input', { type: 'checkbox', checked: true });
  const status = element('p', { className: 'export-status', role: 'status' });
  const progress = element('progress', { max: 1, value: 0, hidden: true });
  const preview = element('div', { className: 'export-preview' });
  const create = element('button', { className: 'button primary', type: 'button', textContent: t('Create') });
  const download = element('a', { className: 'button', textContent: t('Download'), hidden: true });
  const share = element('button', { className: 'button', type: 'button', textContent: t('Share'), hidden: true });
  const close = element('button', { className: 'button', type: 'button', textContent: t('Close') });
  let file = null;
  let url = null;
  let busy = false;

  dialog.replaceChildren(
    element('h2', { id: 'export-title', textContent: t('Save animation') }),
    formats,
    aspects,
    element('label', { className: 'choice' }, caption, element('span', { textContent: t('Include caption') })),
    progress,
    status,
    preview,
    element('div', { className: 'toolbar' }, create, download, share, close),
  );

  canExportVideo().then(ok => {
    if (ok) return;
    const mp4 = formats.querySelector('input[value=mp4]');
    mp4.disabled = true;
    mp4.closest('label').querySelector('small').textContent = t('Not supported by this browser');
    formats.querySelector('input[value=gif]').checked = true;
  });

  const reset = () => {
    if (url) URL.revokeObjectURL(url);
    file = url = null;
    preview.replaceChildren();
    download.hidden = share.hidden = true;
    status.textContent = '';
  };
  dialog.addEventListener('change', reset);

  create.onclick = async () => {
    const source = getSource();
    if (!source || busy) return;
    reset();
    busy = true;
    create.disabled = close.disabled = true;
    progress.hidden = false;
    progress.value = 0;
    status.textContent = t('Recording...');
    pause(true);
    try {
      file = await exportClip(source, {
        format: formats.querySelector('input:checked').value,
        aspect: aspects.querySelector('input:checked').value,
        caption: caption.checked,
        onProgress: value => { progress.value = value; },
      });
      url = URL.createObjectURL(file);
      preview.append(file.type === 'image/gif'
        ? element('img', { src: url, alt: '' })
        : element('video', { src: url, autoplay: true, loop: true, muted: true, playsInline: true, controls: true }));
      download.href = url;
      download.download = file.name;
      download.hidden = false;
      share.hidden = !navigator.canShare?.({ files: [file] });
      status.textContent = `${file.name} · ${(file.size / 1024 / 1024).toFixed(1)} MB`;
    } catch (error) {
      console.error(error);
      status.textContent = t('Could not create the file.');
    } finally {
      pause(false);
      busy = false;
      create.disabled = close.disabled = false;
      progress.hidden = true;
    }
  };

  share.onclick = async () => {
    try {
      await navigator.share({ files: [file], title: 'BuddyRevival' });
    } catch {}
  };

  close.onclick = () => dialog.close();
  dialog.addEventListener('cancel', event => { if (busy) event.preventDefault(); });

  return () => {
    reset();
    dialog.showModal();
  };
}
