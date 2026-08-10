import { Controller, Get } from '@nestjs/common';
import { AppControlService } from './app-control.service';

@Controller('app')
export class AppControlController {
  constructor(private readonly appControl: AppControlService) {}

  /** Public — Flutter polls this as the primary authority for kill-switch / updates. */
  @Get('status')
  status() {
    return this.appControl.getPublicStatus();
  }
}
