const { DataTypes } = require('sequelize');
const sequelize = require('../../config/database');

const Role = sequelize.define('Role', {
    role_id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    ten_role: {
        type: DataTypes.STRING,
        allowNull: false
    },
    mo_ta: {
        type: DataTypes.TEXT
    }
}, {
    tableName: 'role',
    timestamps: false
});

module.exports = Role;
