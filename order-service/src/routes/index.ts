import { Router } from 'express';
import { createOrder } from './controller.ts';
import { validateCreateOrder } from './validator.ts'

const router = Router();


router.post('/', validateCreateOrder, createOrder);

export default router;