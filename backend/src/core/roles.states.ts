// backend/src/core/roles.states.ts

/**
 * System Roles
 * Ordered by authority level (low → high)
 */
export enum SystemRole {
  USER = 'USER',
  MERCHANT = 'MERCHANT',
  CREATOR = 'CREATOR',
  SUPPORT = 'SUPPORT',
  ADMIN = 'ADMIN',
  OWNER = 'OWNER',
}

/**
 * Role Hierarchy
 * Higher role inherits permissions of lower roles.
 */
export const ROLE_HIERARCHY: Record<SystemRole, SystemRole[]> =
  {
    [SystemRole.USER]: [],
    [SystemRole.MERCHANT]: [SystemRole.USER],
    [SystemRole.CREATOR]: [SystemRole.USER],
    [SystemRole.SUPPORT]: [SystemRole.USER],
    [SystemRole.ADMIN]: [
      SystemRole.USER,
      SystemRole.MERCHANT,
      SystemRole.CREATOR,
      SystemRole.SUPPORT,
    ],
    [SystemRole.OWNER]: [
      SystemRole.USER,
      SystemRole.MERCHANT,
      SystemRole.CREATOR,
      SystemRole.SUPPORT,
      SystemRole.ADMIN,
    ],
  };

/**
 * Role Escalation Rules
 * Explicitly defines allowed promotions.
 */
export const ROLE_ESCALATION: Record<
  SystemRole,
  SystemRole[]
> = {
  [SystemRole.USER]: [
    SystemRole.MERCHANT,
    SystemRole.CREATOR,
    SystemRole.SUPPORT,
  ],
  [SystemRole.MERCHANT]: [],
  [SystemRole.CREATOR]: [],
  [SystemRole.SUPPORT]: [],
  [SystemRole.ADMIN]: [],
  [SystemRole.OWNER]: [],
};

/**
 * Role Downgrade Rules
 * Used in moderation / risk response.
 */
export const ROLE_DOWNGRADE: Record<
  SystemRole,
  SystemRole[]
> = {
  [SystemRole.OWNER]: [SystemRole.ADMIN],
  [SystemRole.ADMIN]: [SystemRole.SUPPORT, SystemRole.USER],
  [SystemRole.SUPPORT]: [SystemRole.USER],
  [SystemRole.MERCHANT]: [SystemRole.USER],
  [SystemRole.CREATOR]: [SystemRole.USER],
  [SystemRole.USER]: [],
};

/**
 * Helper: Check if roleA has authority over roleB
 */
export function hasRoleAuthority(
  roleA: SystemRole,
  roleB: SystemRole,
): boolean {
  if (roleA === roleB) return true;
  return ROLE_HIERARCHY[roleA]?.includes(roleB) ?? false;
}
