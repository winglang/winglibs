import { Handler } from "./index.wing";

export const handler: Handler = async ({ myBucket, myQueue }, event: any) => {
  await myBucket.put("hello.txt", "from typescript");
  await myQueue.push("hello");

  console.log("Welcome to TypeScript");
  console.log("event:", event);

  const output = await myBucket.list();
  console.log(output);

  return {
    status: 200,
    body: JSON.stringify({
      message: "Hello, TypeScript",
      event,
    }),
  };
};