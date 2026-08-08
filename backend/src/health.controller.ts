import { Controller, Get } from '@nestjs/common';

@Controller('health')
export class HealthController {
  @Get()
  check() {
    return {
      status: 'ok',
      service: 'kayan-api',
      version: '1.0.0-phase1',
      timestamp: new Date().toISOString(),
    };
  }
}
