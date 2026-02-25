const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Category = sequelize.define('LoaiBatDongSan', {
    loai_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten_loai: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    tableName: 'loai_bat_dong_san',
    timestamps: false
});

module.exports = Category;
