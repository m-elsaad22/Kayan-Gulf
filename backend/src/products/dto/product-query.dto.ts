import { Transform } from 'class-transformer';
import { IsNumber, IsOptional, IsString } from 'class-validator';

export class ProductQueryDto {
  @IsOptional()
  @IsString()
  categorySlug?: string;

  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @Transform(({ value }) => (value !== undefined ? Number(value) : undefined))
  @IsNumber()
  minPrice?: number;

  @IsOptional()
  @Transform(({ value }) => (value !== undefined ? Number(value) : undefined))
  @IsNumber()
  maxPrice?: number;

  @IsOptional()
  @Transform(({ value }) => (value !== undefined ? Number(value) : undefined))
  @IsNumber()
  minRating?: number;

  @IsOptional()
  @IsString()
  sort?: string;

  @IsOptional()
  inStockOnly?: boolean | string;

  @IsOptional()
  onSaleOnly?: boolean | string;

  @IsOptional()
  @Transform(({ value }) => (value !== undefined ? Number(value) : undefined))
  @IsNumber()
  page?: number;
}
