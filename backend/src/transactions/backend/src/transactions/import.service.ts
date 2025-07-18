import { Injectable } from '@nestjs/common';

@Injectable()
export class ImportService {
  async importTransactions(data: any): Promise<any> {
    // TODO: replace stub with real logic
    return { success: true, imported: Array.isArray(data) ? data.length : 0 };
  }
}
