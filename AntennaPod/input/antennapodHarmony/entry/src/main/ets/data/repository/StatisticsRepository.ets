import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { FeedStatistics } from '../../model/EpisodeModel';

// Derived per-feed statistics (time played, episodes started/total/downloaded).
// All values are aggregate COUNT/SUM queries — never stored as columns.
export class StatisticsRepository {
  private static instance: StatisticsRepository | null = null;

  private constructor() {
  }

  static getInstance(): StatisticsRepository {
    if (StatisticsRepository.instance === null) {
      StatisticsRepository.instance = new StatisticsRepository();
    }
    return StatisticsRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async getStatistics(): Promise<FeedStatistics[]> {
    const store = await this.getStore();
    const sql = 'SELECT f.id AS feed_id, f.title AS title, ' +
      'COUNT(fi.id) AS total, ' +
      'SUM(CASE WHEN fi.read = 1 THEN 1 ELSE 0 END) AS started, ' +
      'SUM(CASE WHEN fi.downloaded = 1 THEN 1 ELSE 0 END) AS downloaded, ' +
      'SUM(CASE WHEN fi.read = 1 THEN MAX(fi.media_position, 0) ELSE 0 END) AS time_played ' +
      'FROM Feed f LEFT JOIN FeedItem fi ON fi.feed_id = f.id ' +
      'WHERE f.state = 0 ' +
      'GROUP BY f.id, f.title ORDER BY time_played DESC';
    const rs = await store.querySql(sql);
    const stats: FeedStatistics[] = [];
    if (rs.goToFirstRow()) {
      do {
        const s = new FeedStatistics();
        s.feedId = rs.getLong(rs.getColumnIndex('feed_id'));
        s.title = rs.getString(rs.getColumnIndex('title'));
        s.episodesTotal = rs.getLong(rs.getColumnIndex('total'));
        s.episodesStarted = rs.getLong(rs.getColumnIndex('started'));
        s.episodesDownloaded = rs.getLong(rs.getColumnIndex('downloaded'));
        s.timePlayedMs = rs.getLong(rs.getColumnIndex('time_played'));
        stats.push(s);
      } while (rs.goToNextRow());
    }
    rs.close();
    return stats;
  }
}
