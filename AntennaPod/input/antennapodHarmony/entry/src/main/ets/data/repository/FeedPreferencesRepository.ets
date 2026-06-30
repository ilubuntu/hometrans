import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { FeedPreferences, NewEpisodeAction } from '../../model/EpisodeModel';

// Owns the FeedPreferences table (per-feed settings: autodownload, autodelete,
// new-episode action, playback speed, skip intro/outro, credentials,
// volume reduction).
export class FeedPreferencesRepository {
  private static instance: FeedPreferencesRepository | null = null;

  private constructor() {
  }

  static getInstance(): FeedPreferencesRepository {
    if (FeedPreferencesRepository.instance === null) {
      FeedPreferencesRepository.instance = new FeedPreferencesRepository();
    }
    return FeedPreferencesRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async get(feedId: number): Promise<FeedPreferences> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT * FROM FeedPreferences WHERE feed_id = ' + feedId.toString());
    const prefs = this.defaults(feedId);
    if (rs.goToFirstRow()) {
      prefs.autoDownload = rs.getLong(rs.getColumnIndex('auto_download')) !== 0;
      prefs.autoDelete = rs.getLong(rs.getColumnIndex('auto_delete')) !== 0;
      prefs.newEpisodeAction = rs.getLong(rs.getColumnIndex('new_episode_action'));
      prefs.playbackSpeed = rs.getDouble(rs.getColumnIndex('playback_speed'));
      prefs.skipIntro = rs.getLong(rs.getColumnIndex('skip_intro'));
      prefs.skipOutro = rs.getLong(rs.getColumnIndex('skip_outro'));
      prefs.username = rs.getString(rs.getColumnIndex('username'));
      prefs.password = rs.getString(rs.getColumnIndex('password'));
      prefs.volumeReduction = rs.getLong(rs.getColumnIndex('volume_reduction')) !== 0;
    }
    rs.close();
    return prefs;
  }

  async set(prefs: FeedPreferences): Promise<void> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = {
      feed_id: prefs.feedId,
      auto_download: prefs.autoDownload ? 1 : 0,
      auto_delete: prefs.autoDelete ? 1 : 0,
      new_episode_action: prefs.newEpisodeAction,
      playback_speed: prefs.playbackSpeed,
      skip_intro: prefs.skipIntro,
      skip_outro: prefs.skipOutro,
      username: prefs.username,
      password: prefs.password,
      volume_reduction: prefs.volumeReduction ? 1 : 0
    } as relationalStore.ValuesBucket;
    await store.insert('FeedPreferences', bucket, relationalStore.ConflictResolution.ON_CONFLICT_REPLACE);
    const p = new EventPayload();
    p.feedId = prefs.feedId;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  private defaults(feedId: number): FeedPreferences {
    const prefs = new FeedPreferences();
    prefs.feedId = feedId;
    prefs.autoDelete = true;
    prefs.newEpisodeAction = NewEpisodeAction.ADD_TO_INBOX;
    prefs.playbackSpeed = 1.0;
    return prefs;
  }
}
