import express from 'express';
import orderRoutes from './routes/index.ts';

const PORT = process.env.PORT || 3005;

const app = express();
app.use(express.json());

app.use('/orders', orderRoutes);

app.listen(PORT, () => {
  console.log(`Order Process started at port ${PORT}`);
})

process.on('uncaughtException', (exception) => {
  console.log("Exception occurred", exception)
})