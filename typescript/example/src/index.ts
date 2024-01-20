exports.handler = async (event, context) => {
  console.log("Welcome to TypeScript", event);
  return {
    status: 200,
    body: JSON.stringify({ message: "Hello, TypeScript" }),
  };
};