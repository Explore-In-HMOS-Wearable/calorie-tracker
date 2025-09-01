import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { MacroModel } from '../core/models/MacroModel';
import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';
import { HomePage } from './HomePage';
import { SetMacroPage } from './SetMacroPage';


@Entry
@Component
struct Index {
  trackerService: TrackerService = TrackerService.instance();
  context: UIContext = this.getUIContext();

  aboutToAppear(): void {
    this.trackerService.setHeader(this.context);
    NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
  }

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'HomePage') {
        HomePage();
      } else if (name === 'SetMacroPage') {
        SetMacroPage()
      }
    }.hideTitleBar(true)
  }

  build() {
    Navigation(NavigationService.getInstance().pageInfos) {
      RelativeContainer()
    }
    .onNavBarStateChange((e) => {
      if (NavigationService.getInstance().pageInfos.getAllPathName().length == 0) {
        NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
      }
    })
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
  }
}
