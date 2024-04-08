import {
	Body,
	Controller,
	Get,
	Path,
	Post,
	Query,
	Route,
	SuccessResponse,
	Request,
} from "tsoa";

import { getClient } from "../clients.js";
import { Request as Req } from "express";

interface User {
	id: number;
	email: string;
	name: string;
	status?: "Happy" | "Sad";
	phoneNumbers: string[];
}

interface UserCreationParams {
	id: number;
	email: string;
	name: string;
	status?: "Happy" | "Sad";
	phoneNumbers: string[];
}
@Route("users")
export class UsersController extends Controller {
	@Get("{userId}")
	public async getUser(
		@Path() userId: number,
		@Request() request: Req,
		@Query() name?: string,
	): Promise<User> {
		let bucket = getClient(request, "bucket");
		bucket.put(userId.toString(), name ?? "not-a-name");

    return  {
      id :userId,
      name: name ?? "not-a-name",
      status: "Happy",
      email:"email",
      phoneNumbers: ["a"]
    }
	}

	@SuccessResponse("201", "Created") // Custom success response
	@Post()
	public async createUser(
		@Body() requestBody: UserCreationParams,
	): Promise<void> {
		this.setStatus(201); // set return status 201
		return;
	}
}
