import { WebSocket } from "ws";

export const _ws = async (url: string): Promise<WebSocket> => {
  return new WebSocket(url);
}

export const _buffer_to_string = async (data: string): Promise<string> => {
  return Buffer.from(data).toString();
}