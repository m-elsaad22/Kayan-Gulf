/** Runtime class so Nest emitDecoratorMetadata can reference it. */
export class AuthUser {
  userId!: string;
  email!: string | null;
  phone!: string | null;
  role!: string;
}
