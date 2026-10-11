import { t } from '../domain/i18n.js';

const ICON_SIZE = 36;

const hex = color => `#${(color & 0xffffff).toString(16).padStart(6, '0')}`;

const element = (tag, props = {}) => Object.assign(document.createElement(tag), props);

const readableName = icon => icon.replace(/^(Icon|Char)_/, '').replace(/_/g, ' ');

export async function renderWardrobe(root, wardrobe, buddy, onChange) {
  const icons = await buddy.textures.icons();
  let openSelector = null;

  const thumbnail = name => {
    const frame = element('span', { className: 'icon' });
    const icon = icons[name];
    if (icon) {
      const image = frame.appendChild(element('img', { src: icon.url, alt: '' }));
      image.style.left = `${ICON_SIZE / 2 + icon.x}px`;
      image.style.top = `${ICON_SIZE / 2 + icon.y}px`;
    }
    return frame;
  };

  const swatch = (selector, index) => selector.colors
    ? element('span', { className: 'swatch', style: `background:${hex(selector.colors[index])}` })
    : thumbnail(selector.icons[index]);

  const choices = selector => {
    const grid = element('div', { className: selector.colors ? 'choices colors' : 'choices' });
    (selector.colors ?? selector.icons).forEach((_, index) => {
      const choice = grid.appendChild(element('button', {
        ariaPressed: index === selector.get(),
        ariaLabel: selector.colors ? hex(selector.colors[index]) : readableName(selector.icons[index]),
      }));
      choice.append(swatch(selector, index));
      choice.onclick = async () => {
        openSelector = null;
        await wardrobe.choose(buddy, selector, index);
        draw();
        onChange();
      };
    });
    return grid;
  };

  const draw = () => {
    root.replaceChildren();
    for (const option of wardrobe.visibleOptions(buddy)) {
      const row = root.appendChild(element('div', { className: 'option' }));
      row.append(element('span', { className: 'option-name', textContent: t(option.name) }));
      for (const selector of option.selectors) {
        const picker = row.appendChild(element('button', {
          className: 'picker',
          ariaExpanded: openSelector === selector.id,
          ariaLabel: `${t(option.name)} ${selector.kind === 'color' ? t('color') : ''}`.trim(),
        }));
        picker.append(swatch(selector, selector.get()));
        picker.onclick = () => {
          openSelector = openSelector === selector.id ? null : selector.id;
          draw();
        };
        if (openSelector === selector.id) root.append(choices(selector));
      }
    }
  };

  draw();
  return draw;
}
