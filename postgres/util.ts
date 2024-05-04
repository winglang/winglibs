import { Socket } from "net";
import type extern from "./util.extern";

export const isPortOpen: extern["isPortOpen"] = async (port) => {
  return new Promise((resolve, reject) => {
    const client = new Socket();

    client.connect(port);

    client.once("error", (err) => {
      resolve(false);
    });

    client.once("connect", () => {
      client.end();
      resolve(true);
    });
  });
};