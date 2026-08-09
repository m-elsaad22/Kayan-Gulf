import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AddressesModule } from './addresses/addresses.module';
import { AuthModule } from './auth/auth.module';
import { BookingsModule } from './bookings/bookings.module';
import { CartModule } from './cart/cart.module';
import { ClassifiedsModule } from './classifieds/classifieds.module';
import { DevicesModule } from './devices/devices.module';
import { HealthController } from './health.controller';
import { HomeModule } from './home/home.module';
import { NotificationsModule } from './notifications/notifications.module';
import { OrdersModule } from './orders/orders.module';
import { PaymentsModule } from './payments/payments.module';
import { PrismaModule } from './prisma/prisma.module';
import { ProductsModule } from './products/products.module';
import { ServicesModule } from './services/services.module';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    PrismaModule,
    AuthModule,
    HomeModule,
    ProductsModule,
    CartModule,
    AddressesModule,
    OrdersModule,
    PaymentsModule,
    DevicesModule,
    NotificationsModule,
    ServicesModule,
    BookingsModule,
    ClassifiedsModule,
  ],
  controllers: [HealthController],
})
export class AppModule {}
