import { v4 } from 'uuid';
import type {Buffer} from 'buffer';
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";
import { region, bucket, order_finalized_topic } from '../config.ts';

export const generateOrderId = () => {
  return `ORD-${v4().split('-')[0]}`
}

const uploadToS3 = async (pdfData: Buffer<ArrayBuffer>, key: string) => {
  const s3 = new S3Client({ region })
  await s3.send(new PutObjectCommand({
    Bucket: bucket,
    Key: key,
    Body: pdfData,
    ContentType: "application/pdf"
  }));
  console.log("Successfully uploaded invoice to S3 bucket")
}

const publishEventToFinalizedOrderTopic = async (options: Record<string, string>) => {
  const sns = new SNSClient({ region })
  const message = {
    eventType: "FINALIZED_ORD",
    ...options
  }
  await sns.send(new PublishCommand({
    TopicArn: order_finalized_topic,
    Message: JSON.stringify(message)
  }));
  console.log("Successfully published finalized order event");
}

export const uploadInvoiceAndNotify = async (orderId: string, customerName: string, pdfData: Buffer<ArrayBuffer>) => {
  const key = `orders/${orderId}/invoice.pdf`;

  // Upload invoice to S3 bucket
  await uploadToS3(pdfData, key);

  // Publish event to finalized order topic
  const message = {
    orderId,
    customerName,
    bucket,
    filename: key
  }
  await publishEventToFinalizedOrderTopic(message);
}