const ADMIN_ROLES = new Set(['admin', 'super_admin', 'moderator', 'support']);
const PRIVILEGED = new Set(['admin', 'super_admin']);

export function isAdminRole(role: string | null | undefined): boolean {
  return !!role && ADMIN_ROLES.has(role);
}

export function isPrivilegedAdmin(role: string | null | undefined): boolean {
  return !!role && PRIVILEGED.has(role);
}
