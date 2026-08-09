import { IsOptional, IsString } from 'class-validator';

export class AdsQueryDto {
  @IsOptional()
  @IsString()
  categorySlug?: string;

  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsString()
  sort?: string;

  @IsOptional()
  featuredOnly?: boolean | string;

  @IsOptional()
  page?: number | string;
}
