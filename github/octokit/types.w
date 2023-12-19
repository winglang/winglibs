struct BaseResponse {
	status: num;
}

struct OctoKitListFilesObject {
	filename: str;
}

struct OctoKitListFilesResponse {
	status: num;
	data: Array<OctoKitListFilesObject>;
}

struct OctoKitPullsOptions {
	owner: str;
	repo: str;
	pull_number: num;
}

struct CreatePullResponseData {
	id: num;
}

struct CreatePullResponse extends BaseResponse {
	status: num;
	data:CreatePullResponseData;
}

struct CreatePullOptions {
	owner: str;
	repo: str;
	title: str;
	head: str;
	base: str;
}

interface OctoKitPulls {
	inflight create(options: CreatePullOptions): CreatePullResponse;
	inflight listFiles(options: OctoKitPullsOptions): OctoKitListFilesResponse;
}

struct CreateInstallationAccessTokenObject {
	token: str;
}

struct CreateInstallationAccessTokenResponse {
	status: num;
	data: CreateInstallationAccessTokenObject;
}

struct CreateInstallationAccessTokenOptions {
	installation_id: num;
}

struct ListInstallationsResponseAccount {
	login: str;
}

struct ListInstallationsResponseInstallation {
	id: num;
	account: ListInstallationsResponseAccount;
}

struct ListInstallationsResponse extends BaseResponse {
	data: Array<ListInstallationsResponseInstallation>;
}

interface OctoKitApps {
	inflight listInstallations(): ListInstallationsResponse;
	inflight createInstallationAccessToken(options: CreateInstallationAccessTokenOptions): CreateInstallationAccessTokenResponse;
}

struct GetTreeOptionsObjectTree {
	path: str?;
	type: str?;
	url: str?;
}

struct GetTreeOptionsObject {
	truncated: bool;
	tree: Array<GetTreeOptionsObjectTree>;
}

struct GetTreeOptionsResponse {
	status: num;
	data: GetTreeOptionsObject;
}

struct GetTreeOptions {
	owner: str;
	repo: str;
	tree_sha: str;
	// any value means it will be recursive
	recursive: str?;
}

struct GetRefOptionsResponseDataObject {
	sha: str;
}

struct GetRefOptionsResponseData {
	object: GetRefOptionsResponseDataObject;
}

struct GetRefOptionsResponse extends BaseResponse {
	data: GetRefOptionsResponseData;
}

struct GetRefOptions {
	owner: str;
	repo: str;
	ref: str;
}

struct CreateRefOptions {
	owner: str;
	repo: str;
	ref: str;
	sha: str;
}

interface OctoKitGit {
	inflight getTree(options: GetTreeOptions): GetTreeOptionsResponse;
	inflight getRef(options: GetRefOptions): GetRefOptionsResponse;
	inflight createRef(options: CreateRefOptions): BaseResponse;
}

struct CommentResposeData {
	id: num;
}

struct CommentResponse {
	status: num;
	data: CommentResposeData;
}

struct CreateCommentOptions {
	owner: str;
	repo: str;
	issue_number: num;
	body: str?;
}

struct UpdateCommentOptions {
	owner: str;
	repo: str;
	comment_id: num;
	body: str?;
}

struct DeleteCommentOptions {
	owner: str;
	repo: str;
	comment_id: num;
}

struct ListCommentsResponseObject {
	id: num;
	body: str?;
}

struct ListCommentsResponse {
	status: num;
	data: Array<ListCommentsResponseObject>;
}

struct ListCommentsOptions {
	owner: str;
	repo: str;
	issue_number: num;
	body: str?;
}

interface OctoKitIssues {
	inflight createComment(options: CreateCommentOptions): CommentResponse;
	inflight updateComment(options: UpdateCommentOptions): CommentResponse;
	inflight deleteComment(options: DeleteCommentOptions): CommentResponse;
	inflight listComments(options: ListCommentsOptions): ListCommentsResponse;
}

struct CreateRepoProps {
	name: str;
	private: bool?;
	auto_init: bool?;
}

struct CreateOrgRepoProps extends CreateRepoProps {
	org: str;
}

struct DeleteRepoProps {
	owner: str;
	repo: str;
}

struct CreateOrUpdateFileContentsProps {
	owner: str;
	repo: str;
	path: str;
	message: str;
	content: str;
	branch: str?;
	sha: str?;
}

struct ListReposResponseData {
	full_name: str;
}

pub struct ListReposResponse extends BaseResponse {
	data: Array<ListReposResponseData>;
}

pub struct GetContentProps {
	owner: str;
	repo: str;
	path: str;
	ref: str?;
}

pub struct GetContentResponseData {
	type: str;
	size: num;
	name: str;
	path: str;
	content: str?;
	sha: str;
}

pub struct GetContentResponse extends BaseResponse {
	data: GetContentResponseData;
}

pub struct GetCommitProps {
	owner: str;
	repo: str;
	ref: str;
}

pub struct GetCommitResponseFile {
	filename: str;
	sha: str;
	// "added",
	// "removed",
	// "modified",
	// "renamed",
	// "copied",
	// "changed",
	// "unchanged"
	status: str;
}

pub struct GetCommitResponseData {
	files: Array<GetCommitResponseFile>?;
}

pub struct GetCommitResponse {
	data: GetCommitResponseData;
}

pub struct CompareCommitsProps {
	owner: str;
	repo: str;
	base: str;
	head: str;
}

pub struct CompareCommitsResponseFile {
	filaname: str;
	sha: str;
}

pub struct CompareCommitsResponseCommit {
	sha: str;
}

pub struct CompareCommitsResponseData {
	commits: Array<CompareCommitsResponseCommit>;
}

pub struct CompareCommitsResponse {
	data: CompareCommitsResponseData;
}

struct ListForAuthenticatedUserProps {
	type: str;
}

struct ListForOrgProps {
	org: str;
}

interface OctoKitRepos {
	inflight getContent(options: GetContentProps): GetContentResponse;
	inflight getCommit(options: GetCommitProps): GetCommitResponse;
	inflight compareCommits(options: CompareCommitsProps): CompareCommitsResponse;
	inflight createOrUpdateFileContents(options: CreateOrUpdateFileContentsProps): BaseResponse;
	inflight createForAuthenticatedUser(options: CreateRepoProps): BaseResponse;
	inflight createInOrg(options: CreateOrgRepoProps): BaseResponse;
	inflight delete(options: DeleteRepoProps): BaseResponse;
	inflight listForAuthenticatedUser(options: ListForAuthenticatedUserProps): ListReposResponse;
	inflight listForOrg(options: ListForOrgProps): ListReposResponse;
}

pub struct OctoKit {
	pulls: OctoKitPulls;
	apps: OctoKitApps;
	git: OctoKitGit;
	issues: OctoKitIssues;
	repos: OctoKitRepos;
}
