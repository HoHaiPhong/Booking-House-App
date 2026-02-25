const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Utility = sequelize.define('TienIch', {
    Tien_Ich_ID: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    TenTienIch: {
        type: DataTypes.STRING,
        allowNull: false
    },
    MoTaTienIch: {
        type: DataTypes.TEXT
    }
}, {
    tableName: 'Tien_Ich',
    timestamps: false
});

module.exports = Utility;
