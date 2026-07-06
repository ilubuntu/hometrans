import { EpisodeData } from '../model/EpisodeData';

export enum HomeSectionType {
  CONTINUE_LISTENING,
  SEE_WHATS_NEW,
  GET_SURPRISED,
  CHECK_CLASSICS,
  MANAGE_DOWNLOADS
}

@Observed
export class HomeSection {
  @Track type: HomeSectionType;
  @Track title: string;
  @Track moreLabel: string = '';
  @Track emptyText: string = '';
  @Track isEmpty: boolean = false;
  @Track episodes: EpisodeData[] = [];

  constructor(type: HomeSectionType, title: string) {
    this.type = type;
    this.title = title;
  }
}

export interface OverflowMenuOption {
  id: string;
  label: ResourceStr;
  enabled: boolean;
}

export interface HomeSectionOrderEntry {
  label: string;
  hidden: boolean;
}
