import router from '@ohos.router';

@Entry
@Component
struct Index {
  aboutToAppear(): void {
    router.replaceUrl({ url: 'pages/MainPage' });
  }

  build() {
    Column() {
      Text('AntennaPod')
        .fontSize(24)
        .fontColor($r('app.color.black'))
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.background_light'))
  }
}
