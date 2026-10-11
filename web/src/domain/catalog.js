export const parseXml = text => new DOMParser().parseFromString(text, 'text/xml').documentElement;

export const fetchXml = async url => parseXml(await (await fetch(url)).text());

export const attr = (element, name) => element?.getAttribute(name) ?? '';

export const toIndex = value => Number(value) | 0;

export const children = (elements, ...path) =>
  path.reduce((found, tag) => found.flatMap(e => [...e.children].filter(c => c.tagName === tag)), [].concat(elements ?? []));

export const named = (elements, name) => elements.filter(e => attr(e, 'name') === name);

export const items = catalog => children(catalog, 'group', 'categories', 'itemCategory', 'item');

export const isWorn = item => attr(item, 'visible') === 'true' || attr(item, 'alwaysVis') === 'true';

export const materialOptions = catalog => children(catalog, 'materialOptions', 'materialOption');

export const materialOption = (catalog, name) => named(materialOptions(catalog), name)[0] ?? null;

export const selectedMaterial = option => children(option, 'material')[toIndex(attr(option, 'materialIndex'))] ?? null;
