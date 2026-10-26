/**
 * SPRINT-VERIFY-EFFICIENT · 由变更文件推导 verify 计划（保守 fail-safe）。
 */
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';
import { execFileSync } from 'child_process';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../..');
const MAP_PATH = path.join(ROOT, 'scripts/verify/changed-map.json');
// Copy from changed-map.example.json on first customize.

const LAYER_RANK = { l1: 1, 'l2-core': 2, 'l2-standard': 3 };

export function loadMap(mapPath = MAP_PATH) {
  return JSON.parse(fs.readFileSync(mapPath, 'utf8'));
}

/** @param {string[]} files */
export function planForChangedFiles(files, map = loadMap()) {
  const order = map.layerOrder || ['l1', 'l2-core', 'l2-standard'];
  let layer = 'l1';
  let unmatched = 0;
  const bash = new Set();

  for (const file of files) {
    const norm = file.replace(/^\.\//, '');
    let matched = false;
    for (const rule of map.prefixRules || []) {
      if (norm === rule.prefix || norm.startsWith(rule.prefix)) {
        matched = true;
        if ((LAYER_RANK[rule.layer] || 0) > (LAYER_RANK[layer] || 0)) {
          layer = rule.layer;
        }
        for (const b of rule.bash || []) bash.add(b);
        break;
      }
    }
    if (!matched) {
      unmatched += 1;
    }
  }

  if (unmatched > 0) {
    const def = map.defaultLayer || 'l2-core';
    if ((LAYER_RANK[def] || 0) > (LAYER_RANK[layer] || 0)) {
      layer = def;
    }
  }

  if (!files.length) {
    layer = 'l1';
  }

  return {
    layer,
    bash: [...bash],
    unmatched,
    files: files.length,
    layerOrder: order,
  };
}

function resolveChangedBase(base, root) {
  const explicit = base || process.env.VERIFY_CHANGED_BASE;
  if (explicit) return explicit;
  for (const ref of ['origin/master', 'origin/main', 'master', 'main']) {
    try {
      execFileSync('git', ['rev-parse', '--verify', ref], { cwd: root, stdio: 'pipe' });
      return ref;
    } catch {
      /* try next */
    }
  }
  throw new Error(
    'verify:changed 需要有效 git base：设置 VERIFY_CHANGED_BASE=ref，或确保存在 master/main（本地无远端时常用 VERIFY_CHANGED_BASE=master）',
  );
}

export function gitChangedFiles(base, root = ROOT) {
  const ref = resolveChangedBase(base, root);
  execFileSync('git', ['rev-parse', '--verify', ref], { cwd: root, stdio: 'pipe' });
  const range = `${ref}...HEAD`;
  try {
    const out = execFileSync('git', ['diff', '--name-only', range], {
      cwd: root,
      encoding: 'utf8',
    });
    return out.split('\n').map((l) => l.trim()).filter(Boolean);
  } catch (err) {
    throw new Error(`git diff ${range} 失败：${err instanceof Error ? err.message : String(err)}`);
  }
}

export function layerToVerifyArg(layer) {
  switch (layer) {
    case 'l1':
      return [];
    case 'l2-core':
      return ['--core'];
    case 'l2-standard':
      return ['--standard'];
    default:
      return ['--core'];
  }
}
