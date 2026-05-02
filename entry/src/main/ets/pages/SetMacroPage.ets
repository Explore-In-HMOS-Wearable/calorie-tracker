import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';

@Component
export struct SetMacroPage {
  context: UIContext = this.getUIContext()
  @State gaugeValue: number = 0;
  @State gaugeTargetValue: number = 0;
  @State isSettingTarget: boolean = false;

  aboutToAppear(): void {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      this.gaugeValue = this.getRelatedValue() / 100;
      this.gaugeTargetValue = this.getRelatedTargetValue() / 100;
    } else {
      this.gaugeValue = this.getRelatedValue() / 10;
      this.gaugeTargetValue = this.getRelatedTargetValue() / 10;
    }
  }

  isButtonActive(): boolean {
    return this.gaugeValue <= this.gaugeTargetValue
  }

  getRelatedValue(): number {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        return TrackerService.instance().currentMacroModel.kcal;
      case 'Protein':
        return TrackerService.instance().currentMacroModel.protein;
      case 'Fat':
        return TrackerService.instance().currentMacroModel.fat;
      case 'Carbs':
        return TrackerService.instance().currentMacroModel.carbs;
      default:
        return 0;
    }
  }

  getRelatedTargetValue(): number {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        return TrackerService.instance().targetMacroModel.kcal;
      case 'Protein':
        return TrackerService.instance().targetMacroModel.protein;
      case 'Fat':
        return TrackerService.instance().targetMacroModel.fat;
      case 'Carbs':
        return TrackerService.instance().targetMacroModel.carbs;
      default:
        return 0;
    }
  }

  setParameters() {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        TrackerService.instance().currentMacroModel.kcal = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.kcal = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Protein':
        TrackerService.instance().currentMacroModel.protein = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.protein = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Fat':
        TrackerService.instance().currentMacroModel.fat = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.fat = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Carbs':
        TrackerService.instance().currentMacroModel.carbs = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.carbs = this.getProperValue(this.gaugeTargetValue);
        break;
      default:
        break;
    }
  }

  getProperValue(value: number): number {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      return (value * 100);
    } else {
      return (value * 10);
    }
  }

  quickAdd(amount: number) {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      this.gaugeValue += amount / 100;
    } else {
      this.gaugeValue += amount / 10;
    }
  }

  build() {
    Stack() {
      Gauge({ value: this.gaugeValue, min: 0, max: this.gaugeTargetValue })
        .colors($r('app.color.gauge'))
        .width('100%')
        .height('100%')
        .indicator(null)
        .strokeWidth(18)
        .trackShadow({ radius: 3, offsetX: 3, offsetY: 3 })
        .value(this.gaugeValue)
        .align(Alignment.Center)

      List({ initialIndex: 0 }) {
        ListItem() {
           Text(NavigationService.getInstance().arg)
             .fontSize(18)
             .fontColor(Color.White)
             .fontWeight(FontWeight.Bold)
             .margin({ bottom: 8 })
             .alignSelf(ItemAlign.Center)
        }

        ListItem() {
          Row() {
             Text(this.isSettingTarget ? 'Target: ' : 'Current: ')
                .fontColor(Color.White)
                .fontSize(14)
             Text(this.getProperValue(this.isSettingTarget ? this.gaugeTargetValue : this.gaugeValue).toString())
                .fontSize(22)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }

        ListItem() {
          Row() {
            Button('+1')
              .onClick(() => this.quickAdd(1))
              .margin(1)
              .fontSize(10)
              .fontColor(Color.White)
              .width(42)
              .height(28)
              .padding(0)
              .backgroundColor($r('app.color.gauge'))
            Button('+5')
              .onClick(() => this.quickAdd(5))
              .margin(1)
              .fontSize(10)
              .fontColor(Color.White)
              .width(42)
              .height(28)
              .padding(0)
              .backgroundColor($r('app.color.gauge'))
            if (NavigationService.getInstance().arg === 'Calorie') {
              Button('+50')
                .onClick(() => this.quickAdd(50))
                .margin(1)
                .fontSize(10)
                .fontColor(Color.White)
                .width(42)
                .height(28)
                .padding(0)
                .backgroundColor($r('app.color.gauge'))
              Button('+100')
                .onClick(() => this.quickAdd(100))
                .margin(1)
                .fontSize(10)
                .fontColor(Color.White)
                .width(48)
                .height(28)
                .padding(0)
                .backgroundColor($r('app.color.gauge'))
            }
          }
          .justifyContent(FlexAlign.Center)
          .width('100%')
        }

        ListItem() {
          Slider({ style: SliderStyle.InSet, value: this.isSettingTarget ? this.gaugeTargetValue : this.gaugeValue })
            .showSteps(true)
            .selectedColor($r('app.color.gauge'))
            .onChange((value: number) => {
              if (this.isSettingTarget) {
                this.gaugeTargetValue = value;
              } else {
                this.gaugeValue = value;
              }
            }).margin({ bottom: 8, right: 30, left: 30 });
        };

        ListItem() {
           Button(this.isSettingTarget ? 'Switch to Intake' : 'Switch to Target')
             .onClick(() => { this.isSettingTarget = !this.isSettingTarget })
             .backgroundColor(Color.Transparent)
             .border({ width: 1, color: $r('app.color.gauge') })
             .fontColor($r('app.color.gauge'))
             .fontSize(11)
             .height(26)
             .alignSelf(ItemAlign.Center)
        }

        ListItem() {
          Column() {
            Row() {
              Text('Save')
                .fontSize(16)
                .fontColor(Color.White)
                .textAlign(TextAlign.End)
                .lineHeight(16)
                .fontWeight(FontWeight.Bold)
            }
            .backgroundColor($r('app.color.gauge'))
            .borderRadius(6)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('60%')
            .height('40px')
            .onClick(async () => {
              this.setParameters();
              await TrackerService.instance().syncToPersistence();
              NavigationService.getInstance().pageInfos.clear();
              NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
            })
          }
          .alignItems(HorizontalAlign.Center)
          .width('100%')
          .margin({ top: 8, bottom: 20 })
        }
      }
      .alignListItem(ListItemAlign.Center)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .align(Alignment.Center)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1]]
    })
  }
}
