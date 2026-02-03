// backend/src/bootstrap/lifecycle.manager.ts

import { INestApplication } from '@nestjs/common';

type Signal =
  | 'SIGTERM'
  | 'SIGINT'
  | 'SIGHUP'
  | 'SIGUSR1'
  | 'SIGUSR2'
  | 'uncaughtException'
  | 'unhandledRejection';

export class LifecycleManager {
  private static attached = false;
  private static shuttingDown = false;

  /**
   * Attach lifecycle handlers exactly once
   */
  static attach(app: INestApplication): void {
    if (this.attached) {
      return;
    }
    this.attached = true;

    const handler = async (signal: Signal, error?: any) => {
      if (this.shuttingDown) return;
      this.shuttingDown = true;

      try {
        // Minimal, non-failing log (no external deps)
        // eslint-disable-next-line no-console
        console.error(`[VNC PLATFORM] Shutdown signal received: ${signal}`);

        if (error) {
          // eslint-disable-next-line no-console
          console.error('[VNC PLATFORM] Shutdown error context:', error);
        }

        /**
         * Graceful app shutdown
         * - Stops accepting new connections
         * - Flushes internal providers
         */
        await app.close();

        // eslint-disable-next-line no-console
        console.error('[VNC PLATFORM] Graceful shutdown complete');
      } catch (shutdownErr) {
        // eslint-disable-next-line no-console
        console.error(
          '[VNC PLATFORM] Shutdown failure (forced exit)',
          shutdownErr,
        );
      } finally {
        process.exit(error ? 1 : 0);
      }
    };

    /**
     * OS Signals
     */
    process.on('SIGTERM', () => handler('SIGTERM'));
    process.on('SIGINT', () => handler('SIGINT'));
    process.on('SIGHUP', () => handler('SIGHUP'));
    process.on('SIGUSR1', () => handler('SIGUSR1'));
    process.on('SIGUSR2', () => handler('SIGUSR2'));

    /**
     * Runtime Failures
     */
    process.on('uncaughtException', (err) =>
      handler('uncaughtException', err),
    );

    process.on('unhandledRejection', (reason: any) =>
      handler('unhandledRejection', reason),
    );
  }
}
