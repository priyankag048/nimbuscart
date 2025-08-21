FROM node:22-alpine AS build

WORKDIR /app

COPY src/ src/
COPY tsconfig.json .
COPY package.json .
COPY package-lock.json .

RUN npm ci
RUN npm run build


# Final image
FROM public.ecr.aws/lambda/nodejs:22

COPY --from=build /app/package.json ${LAMBDA_TASK_ROOT}/
COPY --from=build /app/package-lock.json ${LAMBDA_TASK_ROOT}/
COPY --from=build /app/dist ${LAMBDA_TASK_ROOT}/

RUN npm ci --omit=dev

CMD [ "index.handler" ]