import { AddPodcastViewModel, PodcastSearchResult } from '../viewmodel/AddPodcastViewModel';
import { BottomNavigation } from '../components/BottomNavigation';
import router from '@ohos.router';

@Entry
@Component
struct AddPodcastPage {
  @State searchQuery: string = '';
  @State discoveryItems: PodcastSearchResult[] = [];
  @State isLoadingDiscovery: boolean = true;
  @State hasDiscoveryError: boolean = false;
  @State errorMessage: string = '';
  @State currentTab: number = 3;
  private viewModel: AddPodcastViewModel = new AddPodcastViewModel();

  aboutToAppear() {
    this.viewModel.setRefreshCallback((): void => { this.syncFromViewModel(); });
    this.viewModel.onAppear();
  }

  aboutToAboutToDisappear() {
    this.viewModel.onDisappear();
  }

  private syncFromViewModel(): void {
    this.discoveryItems = this.viewModel.discoveryItems;
    this.isLoadingDiscovery = this.viewModel.isLoadingDiscovery;
    this.hasDiscoveryError = this.viewModel.hasDiscoveryError;
    this.errorMessage = this.viewModel.errorMessage;
  }

  private performSearch(): void {
    this.viewModel.search(this.searchQuery);
  }

  private navigateBack(): void {
    if (router.getLength() > 1) {
      router.back();
    } else {
      console.info('TODO: No back stack, replace to SubscriptionsPage');
    }
  }

  build() {
    Column() {
      this.ToolbarBuilder()

      Scroll() {
        Column() {
          this.SearchBarBuilder()
          this.QuickDiscoveryBuilder()
          this.ActionRowsBuilder()
        }
        .width('100%')
        .padding({ bottom: 16 })
      }
      .layoutWeight(1)
      .width('100%')
      .scrollBar(BarState.Auto)
      .align(Alignment.Top)

      BottomNavigation({ currentTab: $currentTab })
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  ToolbarBuilder() {
    // AppBarLayout + MaterialToolbar: navigation icon (Back) + title "Add podcast"
    Row() {
      // Back navigation button (homeAsUpIndicator), 56x56 hit area
      Text('\u2039')
        .fontSize(36)
        .fontWeight(FontWeight.Normal)
        .fontColor($r('app.color.black'))
        .width(56)
        .height(56)
        .textAlign(TextAlign.Center)
        .accessibilityText($r('app.string.toolbar_back_button_content_description'))
        .onClick(() => {
          this.navigateBack();
        })

      Text($r('app.string.add_feed_label'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.black'))
        .layoutWeight(1)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
    .width('100%')
    .height(56)
    .padding({ right: 16 })
    .backgroundColor($r('app.color.background_light'))
  }

  @Builder
  SearchBarBuilder() {
    // CardView (cornerRadius 28dp, elevation 0) > LinearLayout(colorSurfaceContainer, center_vertical)
    Row() {
      // searchButton ImageView (48dp, padding 12dp → 24dp glyph), content-desc "Search podcast…"
      // TODO: Replace placeholder with ic_search when available
      Image($r('app.media.ic_feed_black'))
        .width(24)
        .height(24)
        .fillColor($r('app.color.grey600'))
        .margin({ left: 16 })
        .accessibilityText($r('app.string.search_podcast_hint'))
        .onClick(() => {
          this.performSearch();
        })

      // combinedFeedSearchEditText (layout_weight 1, hint, imeOptions actionSearch)
      TextInput({ text: this.searchQuery, placeholder: $r('app.string.search_podcast_hint') })
        .layoutWeight(1)
        .type(InputType.Normal)
        .backgroundColor(Color.Transparent)
        .fontSize(14)
        .padding({ top: 16, bottom: 16, left: 8, right: 16 })
        .onChange((value: string) => {
          this.searchQuery = value;
        })
        .onSubmit(() => {
          this.performSearch();
        })
    }
    .width('100%')
    .height(56)
    .borderRadius(28)
    .backgroundColor($r('app.color.color_surface_variant_light'))
    .margin({ left: 16, right: 16, top: 8, bottom: 8 })
  }

  @Builder
  QuickDiscoveryBuilder() {
    // QuickFeedDiscoveryFragment: GridView (4 cols) + powered-by / discover-more row
    Column() {
      Stack() {
        if (this.hasDiscoveryError) {
          this.DiscoveryErrorBuilder()
        } else {
          this.DiscoveryGridBuilder()
        }
      }
      .width('100%')

      Row() {
        // poweredByLabel: "Suggestions by Apple Podcasts"
        Text($r('app.string.discover_powered_by_itunes'))
          .fontSize(12)
          .fontColor($r('app.color.grey600'))
          .layoutWeight(1)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        // discover_more: TextButton "Discover more »"
        Text($r('app.string.discover_more'))
          .fontSize(14)
          .fontColor($r('app.color.accent_light'))
          .minHeight(48)
          .textAlign(TextAlign.Center)
          .padding({ left: 8, right: 4, top: 12, bottom: 12 })
          .onClick(() => {
            this.viewModel.openDiscoverMore();
          })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .margin({ left: 16, right: 16, top: 16, bottom: 16 })
  }

  @Builder
  DiscoveryGridBuilder() {
    // discover_grid WrappingGridView: 4 columns, NUM_SUGGESTIONS (12) square covers
    Grid() {
      ForEach(this.discoveryItems, (item: PodcastSearchResult, index: number) => {
        GridItem() {
          this.DiscoveryCoverBuilder(item)
        }
        .onClick(() => {
          this.viewModel.openDiscoveryItem(item);
        })
      }, (item: PodcastSearchResult, index: number) => index.toString())
    }
    .columnsTemplate('1fr 1fr 1fr 1fr')
    .columnsGap(8)
    .rowsGap(8)
    .padding({ top: 8 })
    .width('100%')
  }

  @Builder
  DiscoveryCoverBuilder(item: PodcastSearchResult) {
    // quick_feed_discovery_item: LinearLayout(padding 4dp) > SquareImageView(elevation 4dp)
    Column() {
      if (item.imageUrl.length > 0) {
        Image(item.imageUrl)
          .width('100%')
          .aspectRatio(1)
          .objectFit(ImageFit.Cover)
      } else {
        // Dummy placeholder reserves height before the toplist loads.
        Column()
          .width('100%')
          .aspectRatio(1)
          .backgroundColor($r('app.color.grey100'))
      }
    }
    .width('100%')
    .padding(4)
  }

  @Builder
  DiscoveryErrorBuilder() {
    // errorContainer (centerInParent): errorLabel + errorRetryButton
    Column() {
      if (this.errorMessage.length > 0) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor($r('app.color.grey600'))
          .textAlign(TextAlign.Center)
          .margin({ left: 16, right: 16 })
      }

      Button($r('app.string.retry_label'))
        .type(ButtonType.Normal)
        .fontSize(14)
        .margin({ top: 16 })
        .onClick(() => {
          this.viewModel.retryDiscovery();
          this.syncFromViewModel();
        })
    }
    .width('100%')
    .padding({ top: 24, bottom: 24 })
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }

  @Builder
  ActionRowsBuilder() {
    // Six "AddPodcastTextView"-styled rows (BodyMedium, drawableStart icon, minHeight 48dp)
    Column() {
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.add_podcast_by_url'), () => {
          this.viewModel.showAddByUrlDialog();
        })
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.add_local_folder'), () => {
          this.viewModel.addLocalFolder();
        })
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.search_itunes_label'), () => {
          this.viewModel.searchItunes();
        })
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.search_fyyd_label'), () => {
          this.viewModel.searchFyyd();
        })
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.search_podcastindex_label'), () => {
          this.viewModel.searchPodcastIndex();
        })
      this.ActionRowBuilder($r('app.media.ic_feed_black'),
        $r('app.string.opml_add_podcast_label'), () => {
          this.viewModel.importOpml();
        })
    }
    .width('100%')
  }

  @Builder
  ActionRowBuilder(icon: Resource, label: Resource, action: () => void) {
    Row() {
      // drawableStartCompat icon
      // TODO: Replace placeholder with the correct icon per row (ic_feed/ic_folder/ic_search/ic_download)
      Image(icon)
        .width(24)
        .height(24)
        .fillColor($r('app.color.black'))

      Text(label)
        .fontSize(14)
        .fontColor($r('app.color.black'))
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .margin({ left: 8 })
    }
    .width('100%')
    .height(48)
    .padding({ left: 16, right: 16 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      action();
    })
  }
}
