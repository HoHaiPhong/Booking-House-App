const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Review = sequelize.define('DanhGia', {
    danh_gia_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    so_sao: {
        type: DataTypes.INTEGER,
        validate: { min: 1, max: 5 }
    },
    noi_dung: {
        type: DataTypes.TEXT
    },
    ngay_tao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    nguoi_dung_id: {
        type: DataTypes.INTEGER
    },
    bds_id: {
        type: DataTypes.INTEGER
    }
}, {
    tableName: 'danh_gia',
    timestamps: false
});

module.exports = Review;
