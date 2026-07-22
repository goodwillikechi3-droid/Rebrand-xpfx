import { access, constants } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const repoRoot = path.resolve(__dirname, '..');

const buildScripts = [
  'artifacts/api-server/build.mjs',
];

async function main() {
  for (const rel of buildScripts) {
    const abs = path.join(repoRoot, rel);
    await access(abs, constants.F_OK);
    const { spawnSync } = await import('node:child_process');
    const result = spawnSync(process.execPath, ['--check', abs], {
      cwd: repoRoot,
      encoding: 'utf8',
    });

    if (result.status !== 0) {
      console.error(`Build script syntax check failed for ${rel}`);
      if (result.stdout) console.error(result.stdout);
      if (result.stderr) console.error(result.stderr);
      process.exit(result.status ?? 1);
    }

    console.log(`✓ syntax ok: ${rel}`);
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
