const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
    user: process.env.DB_USER,
    host: process.env.DB_HOST,
    database: process.env.DB_NAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432,
});

async function seedProperties() {
    try {
        await client.connect();
        console.log('Connected to DB');

        // 1. Insert Categories
        console.log('Inserting Categories...');
        await client.query(`
      INSERT INTO loai_bat_dong_san (loai_id, ten_loai) VALUES 
      (1, 'Phòng Trọ'),
      (2, 'Căn Hộ Mini'),
      (3, 'Nhà Nguyên Căn')
      ON CONFLICT (loai_id) DO NOTHING;
    `);

        // 2. Insert Properties (Linking to Admin User ID 1 for now)
        console.log('Inserting Properties...');
        const insertPropQuery = `
      INSERT INTO bat_dong_san (ten_bds, dia_chi, gia_thue, dien_tich, mo_ta, loai_id, nguoi_dung_id, lat, lng) 
      VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING bds_id;
    `;

        // Property 1
        const prop1 = await client.query(insertPropQuery, [
            'Phòng trọ cao cấp Quận 10',
            '123 Đường 3/2, Quận 10, TP.HCM',
            3500000,
            25,
            'Phòng thoáng mát, có máy lạnh, giờ giấc tự do.',
            1, 1, 10.776, 106.660
        ]);
        const bds1 = prop1.rows[0].bds_id;

        // Property 2
        const prop2 = await client.query(insertPropQuery, [
            'Căn hộ mini gần ĐH Bách Khoa',
            '456 Lý Thường Kiệt, Quận 10, TP.HCM',
            5500000,
            40,
            'Full nội thất, ban công rộng, view đẹp.',
            2, 1, 10.772, 106.657
        ]);
        const bds2 = prop2.rows[0].bds_id;

        // Property 3
        const prop3 = await client.query(insertPropQuery, [
            'Nhà nguyên căn hẻm xe hơi',
            '789 Sư Vạn Hạnh, Quận 10, TP.HCM',
            12000000,
            100,
            '3 phòng ngủ, 2 WC, thích hợp gia đình hoặc nhóm bạn.',
            3, 1, 10.770, 106.665
        ]);
        const bds3 = prop3.rows[0].bds_id;

        // 3. Insert Images
        console.log('Inserting Images...');
        const insertImgQuery = `INSERT INTO hinh_anh_bds (bds_id, url) VALUES ($1, $2)`;

        // Images for Prop 1
        await client.query(insertImgQuery, [bds1, 'https://img.freepik.com/free-photo/small-bedroom-interior-design-idea_53876-146197.jpg']);
        await client.query(insertImgQuery, [bds1, 'https://img.freepik.com/free-photo/modern-studio-apartment-design-with-bedroom-living-space_1262-12375.jpg']);

        // Images for Prop 2
        await client.query(insertImgQuery, [bds2, 'https://img.freepik.com/free-photo/cozy-living-room-interior-with-panoramic-window_1262-12322.jpg']);

        // Images for Prop 3
        await client.query(insertImgQuery, [bds3, 'https://img.freepik.com/free-photo/luxury-bedroom-suite-resort-high-key_1150-14914.jpg']);

        console.log('Seed data inserted successfully!');

    } catch (err) {
        console.error('Error seeding properties:', err);
    } finally {
        await client.end();
    }
}

seedProperties();
