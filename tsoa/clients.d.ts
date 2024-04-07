import { Request } from 'express';

declare const getClient: (req: Request, id: string) => any;

export { getClient };
