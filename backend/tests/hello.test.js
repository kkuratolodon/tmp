const request = require('supertest');
const app = require('../src/app');

describe('GET /api/hello', () => {
    it('should return Hello, World!', async () => {
        const res = await request(app).get('/api/hello');
        expect(res.statusCode).toEqual(200);
        expect(res.body).toHaveProperty('message', 'Hello, World!');
    });
});
