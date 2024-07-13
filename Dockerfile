# arm64
#FROM node:18-alpine@sha256:ce68cf246cb7e2ebdce319e13c4c36eef1ddae70a0ea5a1a0fe38fe76db47b04

#AMD64
FROM node:18-alpine@sha256:316e2c24fc36e7278d6eb31b6994a942f2d8ab7ba9d244afb2da4f402b55a996 AS base

FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

COPY package.json yarn.lock* package-lock.json* pnpm-lock.yaml* ./

RUN yarn config set registry 'https://registry.npmmirror.com/'
RUN yarn install

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

RUN yarn build

FROM base AS runner
WORKDIR /app

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/.next/server ./.next/server

EXPOSE 3000
ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]