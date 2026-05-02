import { preferences } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';
import { MacroModel } from '../models/MacroModel';

export class PersistenceService {
  private static readonly PREF_NAME = 'CalorieTrackerPrefs';
  private static readonly KEY_CURRENT = 'current_macros';
  private static readonly KEY_TARGET = 'target_macros';
  private static readonly KEY_HISTORY = 'macro_history';
  private static readonly KEY_LAST_DATE = 'last_date';
  private static instance: PersistenceService;
  private pref?: preferences.Preferences;

  private constructor() {}

  static getInstance(): PersistenceService {
    if (!PersistenceService.instance) {
      PersistenceService.instance = new PersistenceService();
    }
    return PersistenceService.instance;
  }

  async init(context: common.Context) {
    try {
      this.pref = await preferences.getPreferences(context, PersistenceService.PREF_NAME);
    } catch (e) {
      console.error('Failed to get preferences');
    }
  }

  async saveCurrentMacros(model: MacroModel) {
    if (!this.pref) {
      return
    };
    try {
      await this.pref.put(PersistenceService.KEY_CURRENT, JSON.stringify(model));
      await this.pref.flush();
    } catch (e) {
      console.error('Failed to save current macros');
    }
  }

  async saveTargetMacros(model: MacroModel) {
    if (!this.pref) {
      return
    };
    try {
      await this.pref.put(PersistenceService.KEY_TARGET, JSON.stringify(model));
      await this.pref.flush();
    } catch (e) {
      console.error('Failed to save target macros');
    }
  }

  async loadCurrentMacros(): Promise<MacroModel | null> {
    if (!this.pref) {
      return null
    };
    try {
      const data = await this.pref.get(PersistenceService.KEY_CURRENT, '');
      if (data && typeof data === 'string' && data !== '') {
        const obj = JSON.parse(data) as Record<string, number>;
        return new MacroModel(obj.kcal, obj.carbs, obj.protein, obj.fat);
      }
    } catch (e) {
      console.error('Failed to load current macros');
    }
    return null;
  }

  async loadTargetMacros(): Promise<MacroModel | null> {
    if (!this.pref) {
      return null
    };
    try {
      const data = await this.pref.get(PersistenceService.KEY_TARGET, '');
      if (data && typeof data === 'string' && data !== '') {
        const obj = JSON.parse(data) as Record<string, number>;
        return new MacroModel(obj.kcal, obj.carbs, obj.protein, obj.fat);
      }
    } catch (e) {
      console.error('Failed to load target macros');
    }
    return null;
  }

  async saveHistory(history: string) {
    if (!this.pref) {
      return
    };
    try {
      await this.pref.put(PersistenceService.KEY_HISTORY, history);
      await this.pref.flush();
    } catch (e) {
      console.error('Failed to save history');
    }
  }

  async loadHistory(): Promise<string> {
    if (!this.pref) {
      return '[]'
    };
    try {
      return await this.pref.get(PersistenceService.KEY_HISTORY, '[]') as string;
    } catch (e) {
      console.error('Failed to load history');
      return '[]';
    }
  }

  async saveLastDate(date: string) {
    if (!this.pref) {
      return
    };
    try {
      await this.pref.put(PersistenceService.KEY_LAST_DATE, date);
      await this.pref.flush();
    } catch (e) {
      console.error('Failed to save last date');
    }
  }

  async loadLastDate(): Promise<string> {
    if (!this.pref) {
      return ''
    };
    try {
      return await this.pref.get(PersistenceService.KEY_LAST_DATE, '') as string;
    } catch (e) {
      console.error('Failed to load last date');
      return '';
    }
  }
}
