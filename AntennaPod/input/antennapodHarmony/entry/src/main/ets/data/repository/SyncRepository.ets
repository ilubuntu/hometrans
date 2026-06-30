import { RepositoryResult } from '../../model/EpisodeModel';

// gpodder/Nextcloud sync interface. Real transport is deferred to a later
// stage (decision contract "Unknown" boundary). The interface is defined here
// so the data + settings layer can reference sync status without depending on
// network code.
export interface SyncService {
  isEnabled(): Promise<boolean>;
  getUsername(): Promise<string>;
  // Pull remote subscription/episode-state changes and push local changes.
  // Resolves to a structured result; never throws to the caller.
  sync(): Promise<RepositoryResult>;
}

// Stub in-memory implementation. Reports disabled + a no-op sync result so
// settings/preferences wiring is complete without live network transport.
export class StubSyncService implements SyncService {
  async isEnabled(): Promise<boolean> {
    return false;
  }

  async getUsername(): Promise<string> {
    return '';
  }

  async sync(): Promise<RepositoryResult> {
    const result = new RepositoryResult();
    result.ok = false;
    result.errorType = 'sync_disabled';
    result.message = 'Sync is not configured';
    return result;
  }
}

// Repository facade that ViewModels use; backed by the stub service today.
export class SyncRepository {
  private static instance: SyncRepository | null = null;
  private readonly service: SyncService = new StubSyncService();

  private constructor() {
  }

  static getInstance(): SyncRepository {
    if (SyncRepository.instance === null) {
      SyncRepository.instance = new SyncRepository();
    }
    return SyncRepository.instance;
  }

  isEnabled(): Promise<boolean> {
    return this.service.isEnabled();
  }

  getUsername(): Promise<string> {
    return this.service.getUsername();
  }

  sync(): Promise<RepositoryResult> {
    return this.service.sync();
  }
}
