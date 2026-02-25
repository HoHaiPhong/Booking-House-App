const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Property = sequelize.define('BatDongSan', {
    bds_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten_bds: {
        type: DataTypes.STRING,
        allowNull: false
    },
    dia_chi: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    gia_thue: {
        type: DataTypes.DECIMAL(15, 2),
        allowNull: false
    },
    dien_tich: {
        type: DataTypes.INTEGER
    },
    mo_ta: {
        type: DataTypes.TEXT
    },
    trang_thai: {
        type: DataTypes.ENUM('trong', 'da_thue'),
        defaultValue: 'trong'
    },
    lat: {
        type: DataTypes.DOUBLE
    },
    lng: {
        type: DataTypes.DOUBLE
    },
    ngay_tao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    loai_id: {
        type: DataTypes.INTEGER
    },
    nguoi_dung_id: {
        type: DataTypes.INTEGER
    }
}, {
    tableName: 'bat_dong_san',
    timestamps: false
});

module.exports = Property;
