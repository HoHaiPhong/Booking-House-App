const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Booking = sequelize.define('DatLich', {
    dat_lich_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    thoi_gian_bat_dau: {
        type: DataTypes.DATE,
        allowNull: false
    },
    thoi_gian_ket_thuc: {
        type: DataTypes.DATE,
        allowNull: false
    },
    trang_thai: {
        type: DataTypes.STRING, // cho_duyet, xac_nhan, huy, hoan_thanh
        defaultValue: 'cho_duyet'
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
    tableName: 'dat_lich',
    timestamps: false
});

module.exports = Booking;
