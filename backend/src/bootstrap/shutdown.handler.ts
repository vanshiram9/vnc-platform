// backend/src/bootstrap/shutdown.handler.ts

export type ShutdownReason =
  | 'NORMAL'
  | 'DEPLOY'
  | 'INCIDENT'
  | 'SECURITY_BREACH'
  | 'FATAL_ERROR';

interface ShutdownContext {
  reason: ShutdownReason;
  signal?: string;
  error?: any;
  timestamp: string;
}

export class ShutdownHandler {
  private static invoked = false;

  /**
   * Entry point for controlled shutdown.
   * Safe to call multiple times; executes once.
   */
  static async handle(context: ShutdownContext): Promise<void> {
    if (this.invoked) {
      return;
    }
    this.invoked = true;

    try {
      // Minimal logging only (no external dependencies)
      // eslint-disable-next-line no-console
      console.error('[VNC PLATFORM] Shutdown initiated');
      // eslint-disable-next-line no-console
      console.error('[VNC PLATFORM] Context:', {
        reason: context.reason,
        signal: context.signal,
        timestamp: context.timestamp,
      });

      if (context.error) {
        // eslint-disable-next-line no-console
        console.error('[VNC PLATFORM] Error snapshot:', context.error);
      }

      /**
       * Incident escalation path
       * (Freeze / forensic capture handled by security layer)
       */
      if (
        context.reason === 'INCIDENT' ||
        context.reason === 'SECURITY_BREACH'
      ) {
        // Intentionally no imports here
        // Security modules react via process-level hooks
        // eslint-disable-next-line no-console
        console.error(
          '[VNC PLATFORM] Incident shutdown — escalation flagged',
        );
      }
    } catch (err) {
      // eslint-disable-next-line no-console
      console.error(
        '[VNC PLATFORM] Shutdown handler failure',
        err,
      );
    } finally {
      /**
       * Final process exit
       * Non-zero code for incident / fatal shutdowns
       */
      const exitCode =
        context.reason === 'NORMAL' || context.reason === 'DEPLOY'
          ? 0
          : 1;

      process.exit(exitCode);
    }
  }

  /**
   * Helper to build shutdown context consistently
   */
  static context(
    reason: ShutdownReason,
    signal?: string,
    error?: any,
  ): ShutdownContext {
    return {
      reason,
      signal,
      error,
      timestamp: new Date().toISOString(),
    };
  }
}
