const sequelize = require('../../config/database');
const { DataTypes } = require('sequelize');

const User = require('./UserModel');
const Role = require('./RoleModel');
const Property = require('./PropertyModel');
const Category = require('./CategoryModel');
const Booking = require('./BookingModel');
const Review = require('./ReviewModel');
const Image = require('./ImageModel');
const Utility = require('./UtilityModel');
const Message = require('./MessageModel');
const Notification = require('./NotificationModel');

// --- Associations ---

// User & Role
Role.hasMany(User, { foreignKey: 'role_id' });
User.belongsTo(Role, { foreignKey: 'role_id' });

// User & Property
User.hasMany(Property, { foreignKey: 'nguoi_dung_id' });
Property.belongsTo(User, { foreignKey: 'nguoi_dung_id' });

// Category & Property
Category.hasMany(Property, { foreignKey: 'loai_id' });
Property.belongsTo(Category, { foreignKey: 'loai_id' });

// Property & Images
Property.hasMany(Image, { foreignKey: 'bds_id' });
Image.belongsTo(Property, { foreignKey: 'bds_id' });

// Property & Booking
Property.hasMany(Booking, { foreignKey: 'bds_id' });
Booking.belongsTo(Property, { foreignKey: 'bds_id' });
User.hasMany(Booking, { foreignKey: 'nguoi_dung_id' });
Booking.belongsTo(User, { foreignKey: 'nguoi_dung_id' });

// Property & Review
Property.hasMany(Review, { foreignKey: 'bds_id' });
Review.belongsTo(Property, { foreignKey: 'bds_id' });
User.hasMany(Review, { foreignKey: 'nguoi_dung_id' });
Review.belongsTo(User, { foreignKey: 'nguoi_dung_id' });

// Property & Utility (N-N)
const PropertyUtility = sequelize.define('bds_Tien_Ich', {}, { tableName: 'bds_Tien_Ich', timestamps: false });
Property.belongsToMany(Utility, { through: PropertyUtility, foreignKey: 'bds_id', otherKey: 'Tien_Ich_ID' });
Utility.belongsToMany(Property, { through: PropertyUtility, foreignKey: 'Tien_Ich_ID', otherKey: 'bds_id' });

// Chat (Message)
User.hasMany(Message, { as: 'SentMessages', foreignKey: 'gui_tu_id' });
User.hasMany(Message, { as: 'ReceivedMessages', foreignKey: 'gui_den_id' });
Message.belongsTo(User, { as: 'Sender', foreignKey: 'gui_tu_id' });
Message.belongsTo(User, { as: 'Receiver', foreignKey: 'gui_den_id' });

// Notification
User.hasMany(Notification, { foreignKey: 'nguoi_dung_id' });
Notification.belongsTo(User, { foreignKey: 'nguoi_dung_id' });

module.exports = {
    sequelize,
    User,
    Role,
    Property,
    Category,
    Booking,
    Review,
    Image,
    Utility,
    Message,
    Notification
};
