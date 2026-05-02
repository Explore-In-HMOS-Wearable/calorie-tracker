import { MacroModel } from '../models/MacroModel';
import { HistoryRecord } from '../models/HistoryRecord';
import { ComponentContent } from '@kit.ArkUI';
import { PersistenceService } from './PersistenceService';
import { common } from '@kit.AbilityKit';

@Observed
export class TrackerService {
  currentMacroModel: MacroModel = new MacroModel();
  targetMacroModel: MacroModel = new MacroModel(2000, 150, 150, 50);
  history: HistoryRecord[] = [];
  static _instance: TrackerService;

  static instance() {
    if (!TrackerService._instance) {
      TrackerService._instance = new TrackerService();
    }
    return TrackerService._instance;
  }

  async init(context: common.Context) {
    try {
      await PersistenceService.getInstance().init(context);
      const savedCurrent = await PersistenceService.getInstance().loadCurrentMacros();
      if (savedCurrent) {
        this.currentMacroModel.kcal = savedCurrent.kcal;
        this.currentMacroModel.carbs = savedCurrent.carbs;
        this.currentMacroModel.protein = savedCurrent.protein;
        this.currentMacroModel.fat = savedCurrent.fat;
      }
      const savedTarget = await PersistenceService.getInstance().loadTargetMacros();
      if (savedTarget) {
        this.targetMacroModel.kcal = savedTarget.kcal;
        this.targetMacroModel.carbs = savedTarget.carbs;
        this.targetMacroModel.protein = savedTarget.protein;
        this.targetMacroModel.fat = savedTarget.fat;
      }

      const savedHistoryStr = await PersistenceService.getInstance().loadHistory();
      this.history = JSON.parse(savedHistoryStr) as HistoryRecord[];

      const lastDate = await PersistenceService.getInstance().loadLastDate();
      const today = new Date().toDateString();
      if (lastDate && lastDate !== today) {
        // Roll over
        this.history.unshift(new HistoryRecord(lastDate, new MacroModel(
          this.currentMacroModel.kcal,
          this.currentMacroModel.carbs,
          this.currentMacroModel.protein,
          this.currentMacroModel.fat
        )));
        if (this.history.length > 7) {
          this.history = this.history.slice(0, 7);
        }
        this.currentMacroModel.kcal = 0;
        this.currentMacroModel.carbs = 0;
        this.currentMacroModel.protein = 0;
        this.currentMacroModel.fat = 0;
        await this.syncToPersistence();
      }
      await PersistenceService.getInstance().saveLastDate(today);
    } catch (e) {
      console.error('Failed to initialize TrackerService');
    }
  }

  async syncToPersistence() {
    try {
      await PersistenceService.getInstance().saveCurrentMacros(this.currentMacroModel);
      await PersistenceService.getInstance().saveTargetMacros(this.targetMacroModel);
      await PersistenceService.getInstance().saveHistory(JSON.stringify(this.history));
    } catch (e) {
      console.error('Failed to sync to persistence');
    }
  }

  calculateTotalProgress(): number {
    let carbProgress = this.currentMacroModel.carbs / this.targetMacroModel.carbs * 100;
    let protProgress = this.currentMacroModel.protein / this.targetMacroModel.protein * 100;
    let fatProgress = this.currentMacroModel.fat / this.targetMacroModel.fat * 100;
    let kcalProgress = this.currentMacroModel.kcal / this.targetMacroModel.kcal * 100;

    let average = (carbProgress + protProgress + fatProgress + kcalProgress) / 4;

    return average;

  }
}
