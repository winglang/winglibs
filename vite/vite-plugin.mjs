/**
 * @return {import("vite").Plugin}
 */
export const plugin = (options) => {
  // /**
  //  * @type {{
  //  *  env?: string;
  //  *  envName?: string;
  //  * }}
  //  */
  // const context = {};
  return {
    name: "@winglibs/vite",
    // configResolved(config) {
    //   context.env = config.env["VITE_WING_ENV"];
    //   context.envName = config.env["VITE_WING_ENV_NAME"] ?? "wing";
    // },
    transformIndexHtml(html) {
      return html.replace(
        "<head>",
        `<head>\n    <script>window.${options.envName}=Object.freeze({meta:Object.freeze({env:${options.env}})});</script>`
      );
    },
  };
};
