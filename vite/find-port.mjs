import getPort, { portNumbers } from "get-port";

export const findPort = async () => {
  return getPort({
    // Vite usually looks for ports starting from 5173.
    port: portNumbers(5173, 5273),
  });
};
