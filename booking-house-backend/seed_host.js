const { Client } = require('pg');
const bcrypt = require('bcryptjs');
require('dotenv').config();

const client = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
});

async function seedHost() {
    try {
        await client.connect();
        console.log('Connected to DB');

        // Hash password "host123"
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash("host123", salt);

        const query = `
      INSERT INTO nguoi_dung (ho_ten, email, mat_khau, so_dien_thoai, role_id) 
      VALUES ($1, $2, $3, $4, 2) 
      ON CONFLICT (email) DO UPDATE SET 
      mat_khau = EXCLUDED.mat_khau, 
      role_id = 2;
    `;

        // Role 2 = User (can host)
        await client.query(query, ['Chu Nha Vui Tinh', 'host@gmail.com', hashedPassword, '0909000222']);
        console.log('Host (User role) created successfully');
        console.log('Email: host@gmail.com');
        console.log('Pass: host123');

    } catch (err) {
        console.error('Error creating host:', err);
    } finally {
        await client.end();
    }
}

seedHost();
