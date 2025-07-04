# Base Node image
FROM node:18-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Serve with a lightweight web server
FROM node:18-alpine
WORKDIR /app

# Install 'serve' to serve static files
RUN npm install -g serve

# Copy built files from builder stage
COPY --from=builder /app/build /app/dist

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
