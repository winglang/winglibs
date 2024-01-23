import { Handler } from "./index.wing";

export const handler: Handler = async ({ myBucket, myQueue }, event: any) => {
  // await myBucket.put("hello.txt", "world");
  // await myQueue.push("hello");

  console.log("Welcome to TypeScript");
  console.log("event:", event);
  return {
    status: 200,
    body: JSON.stringify({
      message: "Hello, TypeScript",
      event,
    }),
  };
};