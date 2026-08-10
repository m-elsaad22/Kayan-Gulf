import { Module } from '@nestjs/common';
import { AppControlModule } from '../app-control/app-control.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  imports: [AppControlModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
