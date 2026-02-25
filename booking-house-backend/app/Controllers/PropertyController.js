const Property = require('../Models/PropertyModel');
const { Op } = require('sequelize');
const sequelize = require('../../config/database');

const PropertyController = {
    // Lấy danh sách tất cả BĐS
    getAllProperties: async (req, res) => {
        try {
            const properties = await Property.findAll();
            res.json(properties);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy danh sách BĐS", error: error.message });
        }
    },

    // Tìm kiếm theo bán kính
    searchByRadius: async (req, res) => {
        try {
            const { userLat, userLng, radius } = req.query;

            if (!userLat || !userLng || !radius) {
                return res.status(400).json({ message: "Vui lòng cung cấp userLat, userLng và radius" });
            }

            const query = `
                SELECT *, 
                ( 6371 * acos( cos( radians(:userLat) ) * cos( radians( lat ) ) 
                * cos( radians( lng ) - radians(:userLng) ) + sin( radians(:userLat) ) 
                * sin( radians( lat ) ) ) ) AS distance 
                FROM bat_dong_san 
                WHERE ( 6371 * acos( cos( radians(:userLat) ) * cos( radians( lat ) ) 
                * cos( radians( lng ) - radians(:userLng) ) + sin( radians(:userLat) ) 
                * sin( radians( lat ) ) ) ) < :radius 
                ORDER BY distance;
            `;

            const properties = await sequelize.query(query, {
                replacements: { userLat: parseFloat(userLat), userLng: parseFloat(userLng), radius: parseFloat(radius) },
                model: Property,
                mapToModel: true
            });

            res.json(properties);
        } catch (error) {
            res.status(500).json({ message: "Lỗi tìm kiếm theo bán kính", error: error.message });
        }
    },

    // Chi tiết BĐS
    getPropertyDetail: async (req, res) => {
        try {
            const { id } = req.params;
            const property = await Property.findByPk(id); // Có thể include Image nếu dùng Association
            if (!property) return res.status(404).json({ message: "Không tìm thấy BĐS" });
            res.json(property);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy chi tiết BĐS" });
        }
    },

    // Lấy BĐS của người dùng hiện tại (My Properties)
    getMyProperties: async (req, res) => {
        try {
            const userId = req.user.id;
            const properties = await Property.findAll({ where: { nguoi_dung_id: userId } });
            res.json(properties);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy danh sách BĐS của bạn", error: error.message });
        }
    },

    // Tạo BĐS mới (Admin & Host)
    createProperty: async (req, res) => {
        try {
            const { ten_bds, dia_chi, gia_thue, dien_tich, mo_ta, loai_id, lat, lng } = req.body;
            // req.user được gán từ authMiddleware
            const newProperty = await Property.create({
                ten_bds, dia_chi, gia_thue, dien_tich, mo_ta, loai_id, lat, lng,
                nguoi_dung_id: req.user.id
            });
            res.status(201).json(newProperty);
        } catch (error) {
            res.status(500).json({ message: "Lỗi tạo BĐS", error: error.message });
        }
    },

    // Cập nhật BĐS (Admin & Host - Own Property)
    updateProperty: async (req, res) => {
        try {
            const { id } = req.params;
            const { role, id: userId } = req.user;

            const whereClause = { bds_id: id };
            if (role !== 1) { // Nếu không phải Admin thì phải là chủ sở hữu
                whereClause.nguoi_dung_id = userId;
            }

            const updated = await Property.update(req.body, { where: whereClause });
            if (updated[0] === 0) return res.status(404).json({ message: "Không tìm thấy hoặc bạn không có quyền sửa BĐS này" });

            res.json({ message: "Cập nhật thành công" });
        } catch (error) {
            res.status(500).json({ message: "Lỗi cập nhật BĐS" });
        }
    },

    // Xóa BĐS (Admin & Host - Own Property)
    deleteProperty: async (req, res) => {
        try {
            const { id } = req.params;
            const { role, id: userId } = req.user;

            const whereClause = { bds_id: id };
            if (role !== 1) { // Nếu không phải Admin thì phải là chủ sở hữu
                whereClause.nguoi_dung_id = userId;
            }

            const deleted = await Property.destroy({ where: whereClause });
            if (!deleted) return res.status(404).json({ message: "Không tìm thấy hoặc bạn không có quyền xóa BĐS này" });

            res.json({ message: "Xóa thành công" });
        } catch (error) {
            res.status(500).json({ message: "Lỗi xóa BĐS" });
        }
    }
};

module.exports = PropertyController;