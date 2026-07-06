import { DownloadState } from '../../model/EpisodeData';

export interface DownloadService {
  start(episodeId: string): void;
  cancel(episodeId: string): void;
  delete(episodeId: string): void;
  isRunning(): boolean;
}

export interface DownloadServiceListener {
  onStarted(): void;
  onCompleted(): void;
}
