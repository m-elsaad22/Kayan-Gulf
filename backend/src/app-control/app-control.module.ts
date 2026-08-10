import { Module } from '@nestjs/common';
import { AppControlController } from './app-control.controller';
import { AppControlService } from './app-control.service';

@Module({
  controllers: [AppControlController],
  providers: [AppControlService],
  exports: [AppControlService],
})
export class AppControlModule {}
