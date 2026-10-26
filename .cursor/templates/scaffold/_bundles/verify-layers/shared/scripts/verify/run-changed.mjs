#!/usr/bin/env node
/**
 * 按 git 变更执行最小 verify（verify-layers scaffold）。
 * VERIFY_CHANGED_DRY=1 · VERIFY_CHANGED_BASE=ref
 */
import { spawnSync } from 'child_process';
import path from 'path';
import { fileURLToPath } from 'url';
import {
  gitChangedFiles,
  planForChangedFiles,
  layerToVerifyArg,
} from './lib/changed-plan.mjs';

const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const dry = process.env.VERIFY_CHANGED_DRY === '1' || process.argv.includes('--dry-run');

const base = process.env.VERIFY_CHANGED_BASE || process.argv.find((a) => a.startsWith('--base='))?.slice(7);
const files = gitChangedFiles(base, ROOT);
const plan = planForChangedFiles(files);
const layerArgs = layerToVerifyArg(plan.layer);

console.log('== verify:changed ==');
console.log(`files: ${plan.files} · unmatched: ${plan.unmatched} · layer: ${plan.layer}`);
if (files.length) {
  for (const f of files.slice(0, 20)) console.log(`  - ${f}`);
  if (files.length > 20) console.log(`  ... +${files.length - 20} more`);
}

const steps = [];
if (layerArgs.length) {
  steps.push(['bash', ['scripts/verify.sh', ...layerArgs]]);
} else {
  steps.push(['bash', ['scripts/verify.sh']]);
}
for (const rel of plan.bash) {
  steps.push(['bash', [rel]]);
}

for (const [cmd, args] of steps) {
  const line = `${cmd} ${args.join(' ')}`;
  console.log(dry ? `[dry-run] ${line}` : `>> ${line}`);
  if (!dry) {
    const r = spawnSync(cmd, args, { cwd: ROOT, stdio: 'inherit', shell: false });
    if (r.status !== 0) process.exit(r.status ?? 1);
  }
}

if (dry) {
  console.log('[dry-run] verify:changed plan OK');
} else {
  console.log('[verify] verify:changed OK');
}
