import { MacroModel } from '../models/MacroModel';
import { ComponentContent } from '@kit.ArkUI';

@Builder
function buildText() {
  Column() {
    Text(TrackerService.instance().calculateTotalProgress().toFixed(2) + `% of total target`)
      .fontSize('14fp')
      .fontWeight(FontWeight.Bold)
  }
  .margin({ top: 40 })
  .justifyContent(FlexAlign.Center)
}

@ObservedV2
export class TrackerService {
  @Trace currentMacroModel: MacroModel = new MacroModel();
  @Trace targetMacroModel: MacroModel = new MacroModel(2000, 150, 150, 50);
  static _instance: TrackerService;
  header?: ComponentContent<Object>;

  static instance() {
    if (!TrackerService._instance) {
      TrackerService._instance = new TrackerService();
    }
    return TrackerService._instance;
  }

  setHeader(context: UIContext) {
    this.header = new ComponentContent(context, wrapBuilder(buildText));
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