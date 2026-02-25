const { Sequelize } = require('sequelize');
require('dotenv').config();

// Khởi tạo kết nối từ các biến môi trường trong file .env
const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: 'postgres',
        logging: false, // Tắt log các câu lệnh SQL thuần ra console để sạch code
        pool: {
            max: 5,
            min: 0,
            acquire: 30000,
            idle: 10000
        }
    }
);

// Kiểm tra kết nối
sequelize.authenticate()
    .then(() => console.log('Kết nối PostgreSQL thành công!'))
    .catch(err => console.error('Không thể kết nối Database:', err));

module.exports = sequelize;