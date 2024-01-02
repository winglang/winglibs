import { createProbot } from "@probot/adapter-aws-lambda-serverless";
import jwt from "jsonwebtoken";

export interface CreateProbotAdapterOptions {
  appId: number;
  privateKey: string;
  webhookSecret: string;
}

export const createProbotAdapter = async (
  options: CreateProbotAdapterOptions,
) => {
  const probot = createProbot({
    overrides: {
      appId: options.appId,
      privateKey: options.privateKey,
      secret: options.webhookSecret,
    },
  });
  probot.onError((event) => {
    console.error("probot error", event.message);
  });
  return probot;
};

export const createGithubAppJwt = async (appId: string, privateKey: string) => {
  const now = Math.floor(Date.now() / 1000) - 30;
  const expiration = now + 60 * 10; // JWT expiration time (10 minute maximum)

  const payload = {
    iat: now,
    exp: expiration,
    iss: appId,
  };

  return jwt.sign(payload, privateKey.trim().replaceAll("\\n", "\n"), {
    algorithm: "RS256",
  });
};
