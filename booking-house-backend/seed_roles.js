const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
});

async function seed() {
    try {
        await client.connect();
        console.log('Connected to DB');

        const query = `
      INSERT INTO role (role_id, ten_role, mo_ta) VALUES 
      (1, 'Admin', 'Quan tri vien'),
      (2, 'User', 'Nguoi dung (Thue & Cho thue)')
      ON CONFLICT (role_id) DO NOTHING;
    `;

        await client.query(query);
        console.log('Roles inserted successfully');
    } catch (err) {
        console.error('Error seeding roles:', err);
    } finally {
        await client.end();
    }
}

seed();
