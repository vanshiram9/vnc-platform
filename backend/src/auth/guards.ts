// backend/src/auth/guards.ts

import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * JwtAuthGuard
 * Ensures request has a valid JWT.
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}

/**
 * AuthGuards
 * Composite guard helper for shared usage.
 * Can be extended later without touching routes.
 */
@Injectable()
export class AuthGuards implements CanActivate {
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();

    if (!request.user) {
      throw new UnauthorizedException('AUTH_REQUIRED');
    }

    return true;
  }
}
