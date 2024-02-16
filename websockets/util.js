import { WebSocket } from "ws";

export const _ws = (url) => {
  return new WebSocket(url);
}

export const _buffer_to_string = (data) => {
  return Buffer.from(data).toString();
}