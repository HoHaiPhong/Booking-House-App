const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Notification = sequelize.define('ThongBao', {
    thong_bao_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    tieu_de: {
        type: DataTypes.STRING
    },
    noi_dung: {
        type: DataTypes.TEXT
    },
    da_doc: {
        type: DataTypes.BOOLEAN,
        defaultValue: false
    },
    ngay_tao: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    nguoi_dung_id: {
        type: DataTypes.INTEGER
    }
}, {
    tableName: 'thong_bao',
    timestamps: false
});

module.exports = Notification;
