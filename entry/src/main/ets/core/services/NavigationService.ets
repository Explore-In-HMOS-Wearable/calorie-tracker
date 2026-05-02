@Observed
export class NavigationService {
  static _instance: NavigationService;
  pageInfos: NavPathStack = new NavPathStack()
  arg: string = '';

  static getInstance() {
    if (!NavigationService._instance) {
      NavigationService._instance = new NavigationService();
    }
    return NavigationService._instance;
  }
}