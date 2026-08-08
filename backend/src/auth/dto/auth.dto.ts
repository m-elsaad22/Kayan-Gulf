import { IsEmail, IsOptional, IsString, MinLength } from 'class-validator';

export class SendOtpDto {
  @IsString()
  @MinLength(8)
  phone!: string;
}

export class VerifyOtpDto {
  @IsString()
  @MinLength(8)
  phone!: string;

  @IsString()
  @MinLength(6)
  code!: string;
}

export class LoginDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(6)
  password!: string;
}

export class SignUpDto {
  @IsString()
  @MinLength(2)
  name!: string;

  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(8)
  phone!: string;

  @IsString()
  @MinLength(6)
  password!: string;
}

export class RefreshDto {
  @IsString()
  refreshToken!: string;
}

export class LogoutDto {
  @IsOptional()
  @IsString()
  refreshToken?: string;
}
