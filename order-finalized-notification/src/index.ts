import { S3Client, GetObjectCommand } from "@aws-sdk/client-s3";
import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { region, finalized_order_event_type, order_link_topic_arn } from "./config";

const s3 = new S3Client({ region });
const sns = new SNSClient({ region });
console.log("Hello from handler");

type SNSRecord = Record<'Message', string>;
type EventRecord = {
  Records: Record<'Sns', SNSRecord>[]
}

export const handler = async (event: EventRecord) => {
  console.log("Received event: ", JSON.stringify(event, null, 2));
  for (const record of event.Records ?? []) {
    const message = JSON.parse(record.Sns.Message || "{}");
    console.log("message: ", message);
    if (message.eventType !== finalized_order_event_type) {
      console.log("Skipping event");
      continue;
    }
    const { orderId, customerName, bucket, filename } = message;
    if (!orderId || !customerName || !bucket || !filename) {
      console.error("Missing fields in SNS message:", message);
      continue;
    }
    const signedUrl = await getSignedUrl(
      s3,
      new GetObjectCommand({ Bucket: bucket, Key: filename }),
      { expiresIn: 900 }
    );

    const response = {
      type: 'ORDER_LINKS',
      orderId,
      invoiceUrl: signedUrl,
      expiresInSeconds: 900,
      bucket,
      filename,
      ts: new Date().toISOString()
    };

    await sns.send(new PublishCommand({
      TopicArn: order_link_topic_arn,
      Message: JSON.stringify(response),
      MessageAttributes: {
        source: {
          DataType: "String",
          StringValue: "OrderLinkLambda"
        }
      }
    }));
    console.log("Published ORDER_LINKS:", response);
  }
  return "Successfully completed"
};
