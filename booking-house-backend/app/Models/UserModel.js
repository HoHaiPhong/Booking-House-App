const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const User = sequelize.define('NguoiDung', {
    nguoi_dung_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ho_ten: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true
    },
    mat_khau: {
        type: DataTypes.STRING,
        allowNull: false
    },
    so_dien_thoai: {
        type: DataTypes.STRING
    },
    ngay_tao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    role_id: {
        type: DataTypes.INTEGER
    }
}, {
    tableName: 'nguoi_dung',
    timestamps: false
});

module.exports = User;
