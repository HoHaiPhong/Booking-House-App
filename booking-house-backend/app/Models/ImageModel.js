const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Image = sequelize.define('HinhAnh', {
    hinh_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    bds_id: {
        type: DataTypes.INTEGER
    },
    url: {
        type: DataTypes.TEXT,
        allowNull: false
    }
}, {
    tableName: 'hinh_anh_bds',
    timestamps: false
});

module.exports = Image;
