import PDFDocument from "pdfkit";
import { generateOrderId, uploadInvoiceAndNotify } from './service.ts';

export const createOrder = (req, res) => {
  const orderId = generateOrderId();
  const { customerName, items } = req.body;

  const doc = new PDFDocument();
  let buffers = [];
  doc.on("data", buffers.push.bind(buffers));
  doc.on("end", async () => {
    const pdfData = Buffer.concat(buffers);
    await uploadInvoiceAndNotify(orderId, customerName, pdfData);
    res.status(201).json({ message: `Order created successfully with order id ${orderId}` })
  });
  doc.fontSize(20).text(`Invoice for ${customerName}`, { align: "center" });
  doc.moveDown();
  items.forEach((item: Record<string, string | number>, i: number) => {
    doc.fontSize(14).text(`${i + 1}. ${item.name} - $${item.price}`);
  });
  doc.end();
}