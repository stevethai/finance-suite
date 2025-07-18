import { Controller, Post, Body } from '@nestjs/common';
import { ImportService } from './import.service';

@Controller('transactions')
export class ImportController {
  constructor(private readonly importService: ImportService) {}

  @Post('import')
  async import(@Body() payload: any) {
    return this.importService.importTransactions(payload);
  }
}
