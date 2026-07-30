import { spawn } from 'node:child_process';
import { once } from 'node:events';
import { fileURLToPath } from 'node:url';
import { setTimeout as delay } from 'node:timers/promises';

const serverUrl = 'http://127.0.0.1:4173';
const viteEntry = fileURLToPath(new URL('../node_modules/vite/bin/vite.js', import.meta.url));
const playwrightEntry = fileURLToPath(
  new URL('../node_modules/@playwright/test/cli.js', import.meta.url),
);

async function isServerReady() {
  try {
    const response = await fetch(serverUrl, {
      signal: AbortSignal.timeout(1_000),
    });

    return response.ok;
  } catch {
    return false;
  }
}

async function waitForServer(serverProcess) {
  const deadline = Date.now() + 30_000;

  while (Date.now() < deadline) {
    if (serverProcess.exitCode !== null) {
      throw new Error(`Vite exited before becoming ready (code ${serverProcess.exitCode}).`);
    }

    if (await isServerReady()) {
      return;
    }

    await delay(250);
  }

  throw new Error(`Vite did not become ready at ${serverUrl} within 30 seconds.`);
}

async function runPlaywright() {
  const playwrightProcess = spawn(
    process.execPath,
    [playwrightEntry, 'test', ...process.argv.slice(2)],
    {
      cwd: process.cwd(),
      stdio: 'inherit',
    },
  );

  const [exitCode] = await once(playwrightProcess, 'exit');
  return exitCode ?? 1;
}

async function stopServer(serverProcess) {
  if (serverProcess.exitCode !== null) {
    return;
  }

  serverProcess.kill('SIGTERM');

  for (let attempt = 0; attempt < 30 && serverProcess.exitCode === null; attempt += 1) {
    await delay(100);
  }

  if (serverProcess.exitCode === null) {
    serverProcess.kill('SIGKILL');
    await delay(100);
  }
}

let viteProcess;

try {
  if (!(await isServerReady())) {
    viteProcess = spawn(
      process.execPath,
      [viteEntry, '--host', '127.0.0.1', '--port', '4173', '--strictPort'],
      {
        cwd: process.cwd(),
        stdio: 'inherit',
      },
    );

    await waitForServer(viteProcess);
  }

  process.exitCode = await runPlaywright();
} catch (error) {
  console.error(error);
  process.exitCode = 1;
} finally {
  if (viteProcess) {
    await stopServer(viteProcess);
  }
}
