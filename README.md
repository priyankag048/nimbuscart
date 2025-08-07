
# 🛒 NimbusCart

**NimbusCart** is a cloud-native, event-driven order processing system built using microservices. It demonstrates how to design, deploy, and scale resilient services on AWS using infrastructure as code (Terraform).

The system handles product orders, inventory management, invoice generation (PDFs stored in S3), and asynchronous event-driven communication using SQS and Lambda. It ensures high availability, multi-AZ deployment, and modular architecture using Node.js, Python, PostgreSQL, and Redis.

---

## 🚀 What Does the Project Do?

This project simulates a production-grade order system with the following flow:

1. **Order Placement**:  
   A user places an order via the Order Service (Node.js).

2. **Inventory Check**:  
   Order Service sends a message to the Inventory Service (Python) via SQS.

3. **If In Stock**:  
   - The product quantity is decremented in PostgreSQL.  
   - An invoice is generated as a PDF and stored in S3.  
   - The customer receives a success notification (via SNS + Lambda).

4. **If Not In Stock**:  
   - An `out-of-stock` event is emitted.  
   - A fallback notification is triggered.
