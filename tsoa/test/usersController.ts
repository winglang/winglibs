import {
	Body,
	Controller,
	Get,
	Path,
	Post,
	Query,
	Route,
	SuccessResponse,
} from "tsoa";
// import type { User } from "./user.js";
// import type { UserCreationParams } from "./usersService.js";
// import { UsersService } from "./usersService.js";
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
		@Query() name?: string,
	): Promise<User> {
    return  {
      id :userId,
      name: name ?? "not-a-name",
      status: "Happy",
      email:"email",
      phoneNumbers: ["a"]
    }
		// return new UsersService().get(userId, name);
	}

	@SuccessResponse("201", "Created") // Custom success response
	@Post()
	public async createUser(
		@Body() requestBody: UserCreationParams,
	): Promise<void> {
		this.setStatus(201); // set return status 201
		// new UsersService().create(requestBody);
		return;
	}
}
