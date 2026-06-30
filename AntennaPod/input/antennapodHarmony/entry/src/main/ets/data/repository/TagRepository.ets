import { relationalStore } from '@kit.ArkData';
import { PodcastDatabase } from '../db/PodcastDatabase';
import { EventBus, EventType, EventPayload } from '../event/EventBus';
import { Tag } from '../../model/EpisodeModel';

// Owns the Tag + FeedTag tables. Assignment changes publish FEED_LIST_UPDATE so
// subscription filters re-evaluate.
export class TagRepository {
  private static instance: TagRepository | null = null;

  private constructor() {
  }

  static getInstance(): TagRepository {
    if (TagRepository.instance === null) {
      TagRepository.instance = new TagRepository();
    }
    return TagRepository.instance;
  }

  private async getStore(): Promise<relationalStore.RdbStore> {
    return PodcastDatabase.getInstance().getStore();
  }

  async getTags(): Promise<Tag[]> {
    const store = await this.getStore();
    const rs = await store.querySql('SELECT * FROM Tag ORDER BY name COLLATE NOCASE ASC');
    const tags: Tag[] = [];
    if (rs.goToFirstRow()) {
      do {
        const tag = new Tag();
        tag.id = rs.getLong(rs.getColumnIndex('id'));
        tag.name = rs.getString(rs.getColumnIndex('name'));
        tags.push(tag);
      } while (rs.goToNextRow());
    }
    rs.close();
    return tags;
  }

  async createTag(name: string): Promise<number> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = { name: name } as relationalStore.ValuesBucket;
    const newId = await store.insert('Tag', bucket);
    EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
    return newId;
  }

  async renameTag(id: number, name: string): Promise<void> {
    const store = await this.getStore();
    const bindArgs: Array<relationalStore.ValueType> = [name];
    await store.executeSql(
      'UPDATE Tag SET name = ? WHERE id = ' + id.toString(), bindArgs);
    EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
  }

  async deleteTag(id: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('DELETE FROM FeedTag WHERE tag_id = ' + id.toString());
    await store.executeSql('DELETE FROM Tag WHERE id = ' + id.toString());
    EventBus.publish(EventType.FEED_LIST_UPDATE, new EventPayload());
  }

  async assignTag(feedId: number, tagId: number): Promise<void> {
    const store = await this.getStore();
    const bucket: relationalStore.ValuesBucket = {
      feed_id: feedId,
      tag_id: tagId
    } as relationalStore.ValuesBucket;
    await store.insert('FeedTag', bucket, relationalStore.ConflictResolution.ON_CONFLICT_IGNORE);
    const p = new EventPayload();
    p.feedId = feedId;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  async removeTag(feedId: number, tagId: number): Promise<void> {
    const store = await this.getStore();
    await store.executeSql('DELETE FROM FeedTag WHERE feed_id = ' + feedId.toString() +
      ' AND tag_id = ' + tagId.toString());
    const p = new EventPayload();
    p.feedId = feedId;
    EventBus.publish(EventType.FEED_LIST_UPDATE, p);
  }

  async getTagsForFeed(feedId: number): Promise<Tag[]> {
    const store = await this.getStore();
    const rs = await store.querySql(
      'SELECT t.* FROM Tag t INNER JOIN FeedTag ft ON ft.tag_id = t.id WHERE ft.feed_id = ' +
      feedId.toString() + ' ORDER BY t.name COLLATE NOCASE ASC');
    const tags: Tag[] = [];
    if (rs.goToFirstRow()) {
      do {
        const tag = new Tag();
        tag.id = rs.getLong(rs.getColumnIndex('id'));
        tag.name = rs.getString(rs.getColumnIndex('name'));
        tags.push(tag);
      } while (rs.goToNextRow());
    }
    rs.close();
    return tags;
  }
}
