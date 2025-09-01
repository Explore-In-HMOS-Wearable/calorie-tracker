import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';

@Entry
@Component
export struct SetMacroPage {
  @State context: UIContext = this.getUIContext()
  @State gaugeValue: number = 0;
  @State gaugeTargetValue: number = 0;
  @State showWarningText: boolean = false;

  aboutToAppear(): void {

    if (NavigationService.getInstance().arg == 'Calorie') {
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
    switch (NavigationService.getInstance().arg) {
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
    switch (NavigationService.getInstance().arg) {
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
    switch (NavigationService.getInstance().arg) {
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
        console.log('Error');
        break;
    }
  }

  getProperValue(value: number): number {
    if (NavigationService.getInstance().arg == 'Calorie') {
      return (value * 100);
    } else {
      return (value * 10);
    }
  }

  build() {
    Gauge({ value: this.gaugeValue, min: 0, max: this.gaugeTargetValue }) {
      ArcList({ initialIndex: 2 }) {
        ArcListItem() {
          Text(this.getProperValue(this.gaugeValue).toString())
            .fontSize($r(`app.float.menu_item_font_size`))
            .fontColor(Color.White)
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Bold)
            .textShadow({
              radius: 0.01, // very thin
              color: Color.Black,
              offsetX: 0,
              offsetY: 0
            })
            .lineHeight(18);
        };

        ArcListItem() {
          Slider({ style: SliderStyle.InSet, value: this.gaugeValue })
            .showSteps(true)
            .selectedColor($r('app.color.gauge'))
            .onChange((value: number) => {
              this.gaugeValue = value;
            }).margin({ bottom: 10, right: 30, left: 30 });
        };

        ArcListItem() {
          Text(this.getProperValue(this.gaugeTargetValue).toString())
            .fontSize($r(`app.float.menu_item_font_size`))
            .fontColor(Color.White)
            .textAlign(TextAlign.End)
            .fontWeight(FontWeight.Bold)
            .textShadow({
              radius: 0.01, // very thin
              color: Color.Black,
              offsetX: 0,
              offsetY: 0
            })
            .lineHeight(18);
        };

        ArcListItem() {
          Slider({ style: SliderStyle.InSet, value: this.gaugeTargetValue })
            .showSteps(true)
            .selectedColor($r('app.color.gauge'))
            .onChange((value: number) => {
              this.gaugeTargetValue = value;
            }).margin({ bottom: 10, right: 30, left: 30 });
        }

        ArcListItem() {
          Column() {
            Row() {
              Text('Set')
                .fontSize(18)
                .fontColor(Color.White)
                .textAlign(TextAlign.End)
                .lineHeight(18)
                .fontWeight(FontWeight.Bold)
            }
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [[Color.Grey, 0.0],
                [Color.Grey, 1],]
            })
            .borderRadius(6)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('70%')
            .height('65px')
            .onClick(() => {
              if (this.isButtonActive()) {
                this.setParameters();
                TrackerService.instance().setHeader(this.getUIContext());
                NavigationService.getInstance().pageInfos.clear();
                NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
              } else {
                this.showWarningText = true;
              }

            })

            if (this.showWarningText) {
              Text($r('app.string.warning'))
                .fontSize('10fp')
                .fontColor('#FFFF8A8A')
                .textAlign(TextAlign.Center)
                .fontWeight(FontWeight.Bold)
                .margin({ top: 6 })
                .width('50%')
            }
          }
        }
      }
    }
    .colors($r('app.color.gauge'))
    .width('100%')
    .height('100%')
    .indicator(null)
    .strokeWidth(18)
    .trackShadow({ radius: 3, offsetX: 3, offsetY: 3 })
    .value(this.gaugeValue)
    .align(Alignment.Center)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1],]
    })
  }
}