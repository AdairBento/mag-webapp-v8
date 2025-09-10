import { z } from "zod";

export const PaginationSchema = z.object({
  page: z.coerce.number().min(1).default(1),
  limit: z.coerce.number().min(1).max(100).default(20),
  sort: z.string().optional(),
  order: z.enum(["asc", "desc"]).default("desc")
});

export const UUIDSchema = z.string().uuid();

export const MoneyAmountSchema = z.object({
  amount: z.number().min(0),
  currency: z.string().length(3).default("BRL")
});