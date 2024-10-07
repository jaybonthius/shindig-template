import Fastify from 'fastify';
import { ComputeEngine } from '@cortex-js/compute-engine';

const fastify = Fastify({
  logger: {
    level: 'error',
  }
});

const port = 5200;
const ce = new ComputeEngine();

function compareLatexExpressions(latex1, latex2) {
  const expr1 = ce.parse(latex1).simplify().canonical;
  const expr2 = ce.parse(latex2).simplify().canonical;

  return expr1.isSame(expr2);
}

fastify.post('/compare', async (request, reply) => {
  const { latex1, latex2 } = request.body;
  request.log.info(`Comparing LaTeX expressions: ${latex1}, ${latex2}`);

  if (!latex1 || !latex2) {
    reply.code(400).send({ error: 'Both latex1 and latex2 are required.' });
    return;
  }

  try {
    const result = compareLatexExpressions(latex1, latex2);
    reply.send(result);
  } catch (error) {
    request.log.error('Error processing LaTeX expressions:', error);
    reply.code(500).send({ error: 'Error processing LaTeX expressions' });
  }
});

fastify.setNotFoundHandler((request, reply) => {
  reply.code(404).send({ error: 'Not found' });
});

fastify.setErrorHandler((error, request, reply) => {
  request.log.error(error);
  reply.code(500).send({ error: 'Internal server error' });
});

const start = async () => {
  try {
    await fastify.listen({ port });
    console.log(`API running on http://localhost:${port}`);
  } catch (err) {
    fastify.log.error(err);
    process.exit(1);
  }
};

start();