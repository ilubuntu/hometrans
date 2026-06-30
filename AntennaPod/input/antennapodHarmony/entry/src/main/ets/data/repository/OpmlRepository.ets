import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { FeedRepository } from './FeedRepository';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { Feed } from '../../model/EpisodeModel';

// OPML import/export. Export builds an OPML 2.0 document from subscribed feeds;
// import scans <outline ... xmlUrl="..." ...> entries (no regex — pure string
// scanning) and creates a Feed row per discovered URL. Real RSS metadata fetch
// is deferred to the transport stage; here the data path (feed rows) completes.
export class OpmlRepository {
  private static instance: OpmlRepository | null = null;

  private constructor() {
  }

  static getInstance(): OpmlRepository {
    if (OpmlRepository.instance === null) {
      OpmlRepository.instance = new OpmlRepository();
    }
    return OpmlRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  // Build OPML XML for all subscribed feeds.
  async exportOpml(): Promise<string> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT title, download_url, link FROM Feed WHERE state = 0 ORDER BY title COLLATE NOCASE ASC');
    const lines: string[] = [];
    lines.push('<?xml version="1.0" encoding="UTF-8"?>');
    lines.push('<opml version="2.0">');
    lines.push('  <head>');
    lines.push('    <title>AntennaPod subscriptions</title>');
    lines.push('    <dateCreated>' + this.rfc822Date(Date.now()) + '</dateCreated>');
    lines.push('  </head>');
    lines.push('  <body>');
    if (rs.goToFirstRow()) {
      do {
        const title = this.xmlEscape(rs.getString(rs.getColumnIndex('title')));
        const url = this.xmlEscape(rs.getString(rs.getColumnIndex('download_url')));
        const link = this.xmlEscape(rs.getString(rs.getColumnIndex('link')));
        let outline = '    <outline type="rss" text="' + title +
          '" title="' + title + '" xmlUrl="' + url + '"';
        if (link.length > 0) {
          outline += ' htmlUrl="' + link + '"';
        }
        outline += ' />';
        lines.push(outline);
      } while (rs.goToNextRow());
    }
    rs.close();
    lines.push('  </body>');
    lines.push('</opml>');
    return lines.join('\n');
  }

  // Parse OPML and subscribe to every feed URL found. Returns count added.
  async importOpml(xml: string): Promise<number> {
    const urls = this.extractXmlUrls(xml);
    const feedRepo = FeedRepository.getInstance();
    let added = 0;
    for (let i = 0; i < urls.length; i++) {
      const url = urls[i];
      if (url.length > 0) {
        await feedRepo.subscribeByUrl(url);
        added++;
      }
    }
    if (added > 0) {
      EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
    }
    return added;
  }

  // Extract every xmlUrl="..." value via indexOf scanning (no regex literals).
  private extractXmlUrls(xml: string): string[] {
    const urls: string[] = [];
    const key = 'xmlUrl="';
    let cursor = 0;
    for (;;) {
      const at = xml.indexOf(key, cursor);
      if (at < 0) {
        break;
      }
      const start = at + key.length;
      const end = xml.indexOf('"', start);
      if (end < 0) {
        break;
      }
      urls.push(xml.substring(start, end));
      cursor = end + 1;
    }
    return urls;
  }

  private xmlEscape(value: string): string {
    let out = '';
    const len = value.length;
    for (let i = 0; i < len; i++) {
      const ch = value.charAt(i);
      if (ch === '&') {
        out += '&amp;';
      } else if (ch === '<') {
        out += '&lt;';
      } else if (ch === '>') {
        out += '&gt;';
      } else if (ch === '"') {
        out += '&quot;';
      } else if (ch === '\'') {
        out += '&apos;';
      } else {
        out += ch;
      }
    }
    return out;
  }

  // Format a timestamp as an RFC822 date string (e.g. "Mon, 30 Jun 2026 12:00:00 GMT").
  private rfc822Date(timeMs: number): string {
    const days: string[] = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months: string[] = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const d = new Date(timeMs);
    const day = days[d.getUTCDay()];
    const month = months[d.getUTCMonth()];
    const hh = this.pad2(d.getUTCHours());
    const mm = this.pad2(d.getUTCMinutes());
    const ss = this.pad2(d.getUTCSeconds());
    return day + ', ' + this.pad2(d.getUTCDate()) + ' ' + month + ' ' + d.getUTCFullYear() +
      ' ' + hh + ':' + mm + ':' + ss + ' GMT';
  }

  private pad2(n: number): string {
    return n < 10 ? '0' + n.toString() : n.toString();
  }
}
