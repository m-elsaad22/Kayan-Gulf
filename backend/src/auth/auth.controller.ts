import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import {
  LoginDto,
  RefreshDto,
  SendOtpDto,
  SignUpDto,
  VerifyOtpDto,
  GoogleLoginDto,
} from './dto/auth.dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('otp/send')
  sendOtp(@Body() dto: SendOtpDto) {
    return this.auth.sendOtp(dto.phone);
  }

  @Post('otp/verify')
  verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.auth.verifyOtp(dto.phone, dto.code);
  }

  @Post('login')
  login(@Body() dto: LoginDto) {
    return this.auth.login(dto);
  }

  @Post('google')
  google(@Body() dto: GoogleLoginDto) {
    return this.auth.loginWithGoogle(dto);
  }

  @Post('signup')
  signUp(@Body() dto: SignUpDto) {
    return this.auth.signUp(dto);
  }

  @Post('refresh')
  refresh(@Body() dto: RefreshDto) {
    return this.auth.refresh(dto.refreshToken);
  }

  /** Flutter posts with no body; refreshToken is optional. */
  @Post('logout')
  logout(@Body() body?: { refreshToken?: string }) {
    return this.auth.logout(body?.refreshToken);
  }
}
