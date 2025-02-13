# Gunakan Node.js sebagai base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package.json dan package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy semua file dari project ke dalam container
COPY . .

# Expose port 3000 untuk Express
EXPOSE 3000

# Jalankan aplikasi
CMD ["node", "server.js"]
