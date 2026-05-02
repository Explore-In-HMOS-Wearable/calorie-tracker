import { MacroModel } from './MacroModel';

export class HistoryRecord {
  date: string;
  macros: MacroModel;

  constructor(date: string, macros: MacroModel) {
    this.date = date;
    this.macros = macros;
  }
}
