const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Message = sequelize.define('TinNhan', {
    tin_nhan_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    gui_tu_id: {
        type: DataTypes.INTEGER
    },
    gui_den_id: {
        type: DataTypes.INTEGER
    },
    noi_dung: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    thoi_gian_gui: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW
    },
    trang_thai: {
        type: DataTypes.STRING,
        defaultValue: 'sent'
    }
}, {
    tableName: 'tin_nhan',
    timestamps: false
});

module.exports = Message;
