@ObservedV2
export class MacroModel {
  @Trace kcal: number;
  @Trace carbs: number;
  @Trace protein: number;
  @Trace fat: number;

  constructor(kcal: number = 0, carbs: number = 0, protein: number = 0, fat: number = 0) {
    this.kcal = kcal;
    this.carbs = carbs;
    this.protein = protein;
    this.fat = fat;
  }
}