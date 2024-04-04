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
