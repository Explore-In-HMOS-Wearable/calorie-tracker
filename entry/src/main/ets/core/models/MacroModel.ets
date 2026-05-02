@Observed
export class MacroModel {
  kcal: number;
  carbs: number;
  protein: number;
  fat: number;

  constructor(kcal: number = 0, carbs: number = 0, protein: number = 0, fat: number = 0) {
    this.kcal = kcal;
    this.carbs = carbs;
    this.protein = protein;
    this.fat = fat;
  }
}