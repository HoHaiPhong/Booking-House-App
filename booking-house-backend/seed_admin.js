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

async function seedAdmin() {
    try {
        await client.connect();
        console.log('Connected to DB');

        // Hash password "admin123"
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash("admin123", salt);

        const query = `
      INSERT INTO nguoi_dung (ho_ten, email, mat_khau, so_dien_thoai, role_id) 
      VALUES ($1, $2, $3, $4, 1)
      ON CONFLICT (email) DO UPDATE SET 
      mat_khau = EXCLUDED.mat_khau, 
      role_id = 1;
    `;

        await client.query(query, ['Admin System', 'admin@gmail.com', hashedPassword, '0909000111']);
        console.log('Admin user created successfully');
        console.log('Email: admin@gmail.com');
        console.log('Pass: admin123');

    } catch (err) {
        console.error('Error creating admin:', err);
    } finally {
        await client.end();
    }
}

seedAdmin();
