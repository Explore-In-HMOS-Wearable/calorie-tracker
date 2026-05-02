import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';
import { common } from '@kit.AbilityKit';
import { HomePage } from './HomePage';
import { SetMacroPage } from './SetMacroPage';
import { HistoryPage } from './HistoryPage';

@Entry
@Component
struct Index {
  trackerService: TrackerService = TrackerService.instance();
  context: UIContext = this.getUIContext();

  aboutToAppear(): void {
    this.trackerService.init(this.getUIContext().getHostContext() as common.Context).then(() => {
      NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
    }).catch((e: Error) => {
      console.error(`Failed to initialize Index: ${e.message}`);
    });
  }

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'HomePage') {
        HomePage();
      } else if (name === 'SetMacroPage') {
        SetMacroPage()
      } else if (name === 'HistoryPage') {
        HistoryPage()
      }
    }.hideTitleBar(true)
  }

  build() {
    Navigation(NavigationService.getInstance().pageInfos) {
      RelativeContainer()
    }
    .onNavBarStateChange((e) => {
      if (NavigationService.getInstance().pageInfos.getAllPathName().length === 0) {
        NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
      }
    })
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
  }
}