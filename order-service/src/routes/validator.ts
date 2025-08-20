import { body, validationResult } from 'express-validator';

export const validateCreateOrder = async (req, res, next) => {
  await body('customerName', 'customer name is mandatory').notEmpty().run(req);
  await body('items', 'items are mandatory').notEmpty().run(req);
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ message: 'Bad Request' })
  }
  return next();
}