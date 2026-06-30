import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { RowMappers } from './RowMappers';
import { FeedItem, DownloadResult, DownloadErrorType } from '../../model/EpisodeModel';

// Owns the downloaded flag + the DownloadResult download log (REQ-039).
// Every completed download (success or failure) is appended to the log;
// failures carry a structured errorType for the ViewModel to map to a toast.
export class DownloadRepository {
  private static instance: DownloadRepository | null = null;

  private constructor() {
  }

  static getInstance(): DownloadRepository {
    if (DownloadRepository.instance === null) {
      DownloadRepository.instance = new DownloadRepository();
    }
    return DownloadRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  // Completed downloads view: FeedItem rows with downloaded = 1.
  async getDownloads(): Promise<FeedItem[]> {
    const store = await this.getStore();
    const sql = 'SELECT fi.*, f.title AS feed_title FROM FeedItem fi ' +
      'LEFT JOIN Feed f ON f.id = fi.feed_id WHERE fi.downloaded = 1 ' +
      'ORDER BY fi.pub_date_ms DESC';
    const rs = await store.querySql(sql);
    const items = RowMappers.collectFeedItems(rs);
    rs.close();
    return items;
  }

  async getDownloadLog(): Promise<DownloadResult[]> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT * FROM DownloadResult ORDER BY completed_date_ms DESC LIMIT 200');
    const results: DownloadResult[] = [];
    if (rs.goToFirstRow()) {
      do {
        const dr = new DownloadResult();
        dr.id = rs.getLong(rs.getColumnIndex('id'));
        dr.completedDateMs = rs.getLong(rs.getColumnIndex('completed_date_ms'));
        dr.title = rs.getString(rs.getColumnIndex('title'));
        dr.reason = rs.getLong(rs.getColumnIndex('reason'));
        dr.sourceType = rs.getString(rs.getColumnIndex('source_type'));
        dr.feeditemId = rs.getLong(rs.getColumnIndex('feeditem_id'));
        dr.ok = dr.reason === 0;
        dr.errorType = dr.ok ? DownloadErrorType.NONE : DownloadErrorType.ERROR_UNKNOWN;
        results.push(dr);
      } while (rs.goToNextRow());
    }
    rs.close();
    return results;
  }

  // Append a DownloadResult log row (always written, even on failure).
  async addDownloadLog(result: DownloadResult): Promise<number> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = {
      completed_date_ms: result.completedDateMs,
      title: result.title,
      reason: result.reason,
      source_type: result.sourceType,
      feeditem_id: result.feeditemId
    } as relationalStore.ValuesBucket;
    const newId = await store.insert('DownloadResult', bucket);
    const p = new EventPayload();
    p.feedItemId = result.feeditemId;
    p.ok = result.ok;
    p.errorType = result.errorType;
    p.resultId = newId;
    EventBus.publish(EventType.DOWNLOAD_EVENT, p);
    return newId;
  }

  async remove(itemId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql(
      'UPDATE FeedItem SET downloaded = 0 WHERE id = ' + itemId.toString());
    const p = new EventPayload();
    p.feedItemId = itemId;
    EventBus.publish(EventType.DOWNLOAD_EVENT, p);
  }

  async deleteDownloadLog(): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('DELETE FROM DownloadResult');
    EventBus.publish(EventType.DOWNLOAD_EVENT, new EventPayload());
  }
}
