import { WebSocket } from "ws";

export const _ws = (url: string): WebSocket => {
  return new WebSocket(url);
}

export const _buffer_to_string = (data: string): string => {
  return Buffer.from(data).toString();
}