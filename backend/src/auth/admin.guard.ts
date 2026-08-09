import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { AuthUser } from '../common/auth-user';

@Injectable()
export class AdminGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest<{ user?: AuthUser }>();
    const user = request.user;
    if (!user || user.role !== 'admin') {
      throw new ForbiddenException('admin_required');
    }
    return true;
  }
}
