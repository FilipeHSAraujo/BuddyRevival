import { t } from '../domain/i18n.js';

export function renderActions(root, actions, onPick) {
  root.replaceChildren();
  for (const action of actions) {
    const button = root.appendChild(document.createElement('button'));
    button.className = 'action';
    const image = button.appendChild(document.createElement('img'));
    image.src = `assets/icons/${action.icon}.png`;
    image.alt = '';
    button.append(Object.assign(document.createElement('span'), { textContent: t(action.name) }));
    button.onclick = () => {
      root.querySelector('[aria-pressed=true]')?.setAttribute('aria-pressed', false);
      button.ariaPressed = true;
      onPick(action);
    };
  }
}
