import { Module } from '@nestjs/common';
import { DevicesModule } from '../devices/devices.module';
import { FcmService } from './fcm.service';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';

@Module({
  imports: [DevicesModule],
  controllers: [NotificationsController],
  providers: [FcmService, NotificationsService],
  exports: [NotificationsService, FcmService],
})
export class NotificationsModule {}
