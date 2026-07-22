import test from 'node:test';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { once } from 'node:events';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(__dirname, '..');

async function waitForHttp(url, timeoutMs = 10000) {
  const started = Date.now();
  while (Date.now() - started < timeoutMs) {
    try {
      const response = await fetch(url, { signal: AbortSignal.timeout(1000) });
      if (response.ok) {
        return response;
      }
    } catch {
      // retry until the server is ready
    }
    await new Promise((resolve) => setTimeout(resolve, 250));
  }
  throw new Error(`Timed out waiting for ${url}`);
}

async function startServer() {
  const child = spawn(process.execPath, ['artifacts/api-server/dist/index.mjs'], {
    cwd: repoRoot,
    env: { ...process.env, PORT: '0', NODE_ENV: 'test' },
    stdio: ['ignore', 'pipe', 'pipe'],
  });

  let stdout = '';
  let stderr = '';
  child.stdout.on('data', (chunk) => {
    stdout += chunk.toString();
  });
  child.stderr.on('data', (chunk) => {
    stderr += chunk.toString();
  });

  const deadline = Date.now() + 15000;
  let port;
  while (Date.now() < deadline) {
    if (child.exitCode !== null) {
      throw new Error(`Server exited early with code ${child.exitCode}. stdout: ${stdout} stderr: ${stderr}`);
    }

    const portMatch = /port (\d+)/i.exec(stdout + stderr);
    if (portMatch) {
      port = Number(portMatch[1]);
      break;
    }

    await new Promise((resolve) => setTimeout(resolve, 250));
  }

  if (!port) {
    throw new Error(`Server did not report a port. stdout: ${stdout} stderr: ${stderr}`);
  }

  await waitForHttp(`http://127.0.0.1:${port}/livez`);
  return { child, port, stdout: () => stdout, stderr: () => stderr };
}

test('health endpoints expose liveness and readiness information', async () => {
  const { child, port } = await startServer();
  try {
    const livezResponse = await fetch(`http://127.0.0.1:${port}/livez`, { signal: AbortSignal.timeout(5000) });
    assert.equal(livezResponse.status, 200);
    const livezBody = await livezResponse.json();
    assert.equal(livezBody.status, 'ok');

    const readyzResponse = await fetch(`http://127.0.0.1:${port}/readyz`, { signal: AbortSignal.timeout(5000) });
    assert.equal(readyzResponse.status, 200);
    const readyzBody = await readyzResponse.json();
    assert.equal(readyzBody.ready, true);

    const healthDbResponse = await fetch(`http://127.0.0.1:${port}/healthz/db`, { signal: AbortSignal.timeout(5000) });
    assert.equal(healthDbResponse.status, 200);
    const healthDbBody = await healthDbResponse.json();
    assert.equal(healthDbBody.status, 'ok');
    assert.equal(healthDbBody.database, 'disabled');
  } finally {
    child.kill('SIGTERM');
    await once(child, 'exit').catch(() => {});
  }
});
