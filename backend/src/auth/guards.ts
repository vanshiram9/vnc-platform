// ============================================================
// VNC PLATFORM — AUTH GUARDS
// Phase-1 CORE SECURITY
// ============================================================

import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';

import { User } from '../users/user.entity';

/* ----------------------------------------------------------- */
/* Base helper                                                  */
/* ----------------------------------------------------------- */

function extractUser(
  context: ExecutionContext,
): User {
  const request = context
    .switchToHttp()
    .getRequest();

  const user = request.user as User | undefined;

  if (!user) {
    throw new ForbiddenException('AUTH_REQUIRED');
  }

  return user;
}

/* ----------------------------------------------------------- */
/* USER GUARD                                                   */
/* ----------------------------------------------------------- */

@Injectable()
export class UserGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean {
    const user = extractUser(context);

    if (user.status !== 'ACTIVE') {
      throw new ForbiddenException(
        'USER_NOT_ACTIVE',
      );
    }

    return true;
  }
}

/* ----------------------------------------------------------- */
/* ADMIN GUARD                                                  */
/* ----------------------------------------------------------- */

@Injectable()
export class AdminGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean {
    const user = extractUser(context);

    if (
      user.role !== 'ADMIN' &&
      user.role !== 'OWNER'
    ) {
      throw new ForbiddenException(
        'ADMIN_ONLY',
      );
    }

    return true;
  }
}

/* ----------------------------------------------------------- */
/* OWNER GUARD                                                  */
/* ----------------------------------------------------------- */

@Injectable()
export class OwnerGuard implements CanActivate {
  canActivate(
    context: ExecutionContext,
  ): boolean {
    const user = extractUser(context);

    if (user.role !== 'OWNER') {
      throw new ForbiddenException(
        'OWNER_ONLY',
      );
    }

    return true;
  }
}
