import {
  Body,
  Controller,
  Get,
  Param,
  Patch,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  IsArray,
  IsBoolean,
  IsNumber,
  IsOptional,
  IsString,
  MinLength,
} from 'class-validator';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AuthUser, CurrentUser } from '../common/current-user.decorator';
import { ClassifiedsService } from './classifieds.service';
import { AdsQueryDto } from './dto/ads-query.dto';

class CreateAdDto {
  @IsString()
  @MinLength(3)
  title!: string;

  @IsOptional()
  @IsString()
  description?: string;

  @IsOptional()
  @IsNumber()
  price?: number;

  @IsOptional()
  @IsBoolean()
  isFree?: boolean;

  @IsOptional()
  @IsBoolean()
  isNegotiable?: boolean;

  @IsString()
  @MinLength(2)
  city!: string;

  @IsOptional()
  @IsString()
  district?: string;

  @IsString()
  categorySlug!: string;

  @IsOptional()
  @IsString()
  condition?: string;

  @IsOptional()
  @IsArray()
  imageUrls?: string[];
}

class StatusDto {
  @IsString()
  status!: string;
}

@Controller('classifieds')
export class ClassifiedsController {
  constructor(private readonly classifieds: ClassifiedsService) {}

  @Get('categories')
  categories() {
    return this.classifieds.categories();
  }

  @Get('ads/featured')
  featured() {
    return this.classifieds.featured();
  }

  @Get('ads')
  list(@Query() query: AdsQueryDto) {
    return this.classifieds.listAds(query);
  }

  @Get('ads/:slug')
  detail(@Param('slug') slug: string) {
    return this.classifieds.detail(slug);
  }

  @Get('my-ads')
  @UseGuards(JwtAuthGuard)
  myAds(@CurrentUser() user: AuthUser) {
    return this.classifieds.myAds(user.userId);
  }

  @Post('ads')
  @UseGuards(JwtAuthGuard)
  create(@CurrentUser() user: AuthUser, @Body() dto: CreateAdDto) {
    return this.classifieds.create(user.userId, dto);
  }

  @Patch('ads/:id/status')
  @UseGuards(JwtAuthGuard)
  status(
    @CurrentUser() user: AuthUser,
    @Param('id') id: string,
    @Body() dto: StatusDto,
  ) {
    return this.classifieds.updateStatus(user.userId, id, dto.status);
  }
}
