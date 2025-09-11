import { Request, Response, NextFunction } from "express";
import { z, ZodError } from "zod";

export const validate = (schema: z.ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      const validatedData = schema.parse({
        ...req.body,
        ...req.query,
        ...req.params,
      });

      Object.assign(req.body, validatedData);
      Object.assign(req.query, validatedData);
      Object.assign(req.params, validatedData);

      next();
    } catch (error) {
      if (error instanceof ZodError) {
        return res.status(400).json({
          error: "validation failed",
          code: "VALIDATION_ERROR",
          details: error.errors.map((err) => ({
            field: err.path.join("."),
            message: err.message,
            code: err.code,
          })),
        });
      }
      next(error);
    }
  };
};
