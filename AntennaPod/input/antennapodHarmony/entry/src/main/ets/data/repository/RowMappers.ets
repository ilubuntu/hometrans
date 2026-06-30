import { relationalStore } from '@kit.ArkData';
import { Feed, FeedItem, EpisodeMediaInfo } from '../../model/EpisodeModel';

// Maps a ResultSet row into a domain object. Centralized so every repository
// reads columns identically (booleans are stored 0/1 in SQLite).
export class RowMappers {
  static toFeed(rs: relationalStore.ResultSet): Feed {
    const feed = new Feed();
    feed.id = rs.getLong(rs.getColumnIndex('id'));
    feed.title = rs.getString(rs.getColumnIndex('title'));
    feed.customTitle = rs.getString(rs.getColumnIndex('custom_title'));
    feed.author = rs.getString(rs.getColumnIndex('author'));
    feed.link = rs.getString(rs.getColumnIndex('link'));
    feed.description = rs.getString(rs.getColumnIndex('description'));
    feed.downloadUrl = rs.getString(rs.getColumnIndex('download_url'));
    feed.imageUrl = rs.getString(rs.getColumnIndex('image_url'));
    feed.lastUpdate = rs.getString(rs.getColumnIndex('last_update'));
    feed.lastUpdateMs = rs.getLong(rs.getColumnIndex('last_update_ms'));
    feed.state = rs.getLong(rs.getColumnIndex('state'));
    feed.isLocalFeed = rs.getLong(rs.getColumnIndex('is_local')) !== 0;
    feed.hasLastUpdateFailed = rs.getLong(rs.getColumnIndex('has_last_update_failed')) !== 0;
    return feed;
  }

  static toFeedItem(rs: relationalStore.ResultSet): FeedItem {
    const item = new FeedItem();
    item.id = rs.getLong(rs.getColumnIndex('id'));
    item.feedId = rs.getLong(rs.getColumnIndex('feed_id'));
    item.title = rs.getString(rs.getColumnIndex('title'));
    item.description = rs.getString(rs.getColumnIndex('description'));
    item.link = rs.getString(rs.getColumnIndex('link'));
    item.pubDate = rs.getString(rs.getColumnIndex('pub_date'));
    item.pubDateMs = rs.getLong(rs.getColumnIndex('pub_date_ms'));
    item.imageUrl = rs.getString(rs.getColumnIndex('image_url'));
    const readState = rs.getLong(rs.getColumnIndex('read'));
    item.isPlayed = readState !== 0;
    item.isNew = readState === 0;
    item.isDownloaded = rs.getLong(rs.getColumnIndex('downloaded')) !== 0;
    item.autoDownload = rs.getLong(rs.getColumnIndex('auto_download')) !== 0;
    item.isFavorite = rs.getLong(rs.getColumnIndex('is_favorite')) !== 0;
    item.inHistory = rs.getLong(rs.getColumnIndex('in_history')) !== 0;
    item.playedCompletion = rs.getLong(rs.getColumnIndex('played_completion'));
    item.mediaDownloadUrl = rs.getString(rs.getColumnIndex('media_download_url'));

    const media = new EpisodeMediaInfo();
    media.duration = rs.getLong(rs.getColumnIndex('media_duration'));
    media.position = rs.getLong(rs.getColumnIndex('media_position'));
    media.size = rs.getLong(rs.getColumnIndex('media_size'));
    media.mimeType = rs.getString(rs.getColumnIndex('mime_type'));
    media.downloadUrl = rs.getString(rs.getColumnIndex('media_download_url'));
    media.video = rs.getLong(rs.getColumnIndex('video')) !== 0;
    item.media = media;

    // feedTitle is joined separately; default blank if column absent.
    const feedTitleIdx = rs.getColumnIndex('feed_title');
    if (feedTitleIdx >= 0) {
      item.feedTitle = rs.getString(feedTitleIdx);
    }
    // isInQueue is derived via a Queue JOIN/subquery; default false if absent.
    const inQueueIdx = rs.getColumnIndex('in_queue');
    if (inQueueIdx >= 0) {
      item.isInQueue = rs.getLong(inQueueIdx) !== 0;
    }
    return item;
  }

  // Reads the full result set into an array, advancing the cursor.
  static collectFeedItems(rs: relationalStore.ResultSet): FeedItem[] {
    const items: FeedItem[] = [];
    if (!rs.goToFirstRow()) {
      return items;
    }
    do {
      items.push(RowMappers.toFeedItem(rs));
    } while (rs.goToNextRow());
    return items;
  }

  static collectFeeds(rs: relationalStore.ResultSet): Feed[] {
    const feeds: Feed[] = [];
    if (!rs.goToFirstRow()) {
      return feeds;
    }
    do {
      feeds.push(RowMappers.toFeed(rs));
    } while (rs.goToNextRow());
    return feeds;
  }
}
