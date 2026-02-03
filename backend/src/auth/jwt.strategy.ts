// backend/src/auth/jwt.strategy.ts

import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

import { SecretProvider } from '../config/secrets/secret.provider';

interface JwtPayload {
  sub: string;
  iss: string;
  iat?: number;
  exp?: number;
}

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private readonly secrets: SecretProvider) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: secrets.jwtSecret(),
    });
  }

  /**
   * Validate decoded JWT payload
   * Attaches identity to request context
   */
  async validate(payload: JwtPayload) {
    if (!payload || !payload.sub) {
      throw new UnauthorizedException('INVALID_TOKEN');
    }

    if (payload.iss !== 'VNC-PLATFORM') {
      throw new UnauthorizedException('INVALID_ISSUER');
    }

    /**
     * Returned object is attached to request.user
     * Downstream modules fetch full user context as needed
     */
    return {
      identifier: payload.sub,
    };
  }
}
