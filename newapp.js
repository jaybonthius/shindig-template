// app.js

import Fastify from 'fastify';
import cors from '@fastify/cors';
import formbody from '@fastify/formbody';

const fastify = Fastify({ logger: true });

// Register CORS plugin
await fastify.register(cors, { 
  origin: '*' // Allow all origins (for testing purposes)
});

// Register body parser for URL-encoded and JSON bodies
await fastify.register(formbody);

// Handle POST requests to /submit
fastify.post('/submit', async (request, reply) => {
  console.log('Received submissions:');
  console.log(request.body);

  // Send a simple JSON response
  reply.send({ status: 'success', received: request.body });
});

// Start the server
const start = async () => {
  try {
    await fastify.listen({ port: 3000 });
    console.log('Server listening at http://localhost:3000');
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();
