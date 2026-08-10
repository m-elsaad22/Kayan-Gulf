import { Controller, Get, Param, Query } from '@nestjs/common';
import { ServicesService } from './services.service';

@Controller('services')
export class ServicesController {
  constructor(private readonly services: ServicesService) {}

  @Get('categories')
  categories() {
    return this.services.categories();
  }

  @Get()
  list(@Query('categorySlug') categorySlug?: string) {
    return this.services.list(categorySlug);
  }

  @Get(':slug')
  detail(@Param('slug') slug: string) {
    return this.services.detail(slug);
  }
}
