import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { AuthUser } from '../common/auth-user';

const ADMIN_ROLES = new Set(['admin', 'super_admin', 'moderator', 'support']);

/** Roles that may access the admin API surface. */
export function isAdminRole(role: string | undefined | null): boolean {
  return !!role && ADMIN_ROLES.has(role);
}

/** Roles that may mutate destructive controls (suspend, app kill-switch). */
export function isPrivilegedAdmin(role: string | undefined | null): boolean {
  return role === 'admin' || role === 'super_admin';
}

@Injectable()
export class AdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<{ user?: AuthUser }>();
    const user = request.user;
    if (!user || !isAdminRole(user.role)) {
      throw new ForbiddenException('admin_required');
    }
    return true;
  }
}

@Injectable()
export class PrivilegedAdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<{ user?: AuthUser }>();
    const user = request.user;
    if (!user || !isPrivilegedAdmin(user.role)) {
      throw new ForbiddenException('privileged_admin_required');
    }
    return true;
  }
}
