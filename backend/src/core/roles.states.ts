// backend/src/core/roles.states.ts

/**
 * VNC PLATFORM — SYSTEM ROLES
 * FINAL & HARD-LOCKED
 *
 * Roles are derived ONLY from existing backend modules:
 * users, merchant, support, admin, owner
 *
 * No external / generic / future roles are allowed here.
 */

/**
 * Identity Roles
 * (Who the actor is in the system)
 */
export enum SystemRole {
  USER = 'USER',
  MERCHANT = 'MERCHANT',
  SUPPORT = 'SUPPORT',
  ADMIN = 'ADMIN',
  OWNER = 'OWNER',
}

/**
 * Role Hierarchy
 * Higher roles inherit authority of lower roles.
 */
export const ROLE_HIERARCHY: Record<SystemRole, SystemRole[]> = {
  [SystemRole.USER]: [],

  [SystemRole.MERCHANT]: [
    SystemRole.USER,
  ],

  [SystemRole.SUPPORT]: [
    SystemRole.USER,
  ],

  [SystemRole.ADMIN]: [
    SystemRole.USER,
    SystemRole.MERCHANT,
    SystemRole.SUPPORT,
  ],

  [SystemRole.OWNER]: [
    SystemRole.USER,
    SystemRole.MERCHANT,
    SystemRole.SUPPORT,
    SystemRole.ADMIN,
  ],
};

/**
 * Allowed Role Escalation
 * Explicit promotions allowed by system policy.
 */
export const ROLE_ESCALATION: Record<SystemRole, SystemRole[]> = {
  [SystemRole.USER]: [
    SystemRole.MERCHANT,
    SystemRole.SUPPORT,
  ],

  [SystemRole.MERCHANT]: [],
  [SystemRole.SUPPORT]: [],
  [SystemRole.ADMIN]: [],
  [SystemRole.OWNER]: [],
};

/**
 * Allowed Role Downgrade
 * Used during moderation, risk response, compliance actions.
 */
export const ROLE_DOWNGRADE: Record<SystemRole, SystemRole[]> = {
  [SystemRole.OWNER]: [
    SystemRole.ADMIN,
  ],

  [SystemRole.ADMIN]: [
    SystemRole.SUPPORT,
    SystemRole.MERCHANT,
    SystemRole.USER,
  ],

  [SystemRole.SUPPORT]: [
    SystemRole.USER,
  ],

  [SystemRole.MERCHANT]: [
    SystemRole.USER,
  ],

  [SystemRole.USER]: [],
};

/**
 * Authority Check Helper
 * Determines whether roleA has authority over roleB.
 */
export function hasRoleAuthority(
  roleA: SystemRole,
  roleB: SystemRole,
): boolean {
  if (roleA === roleB) return true;
  return ROLE_HIERARCHY[roleA]?.includes(roleB) ?? false;
}
