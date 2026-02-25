const { Booking, Property, User } = require('../Models');

const BookingController = {
    // Tạo lịch đặt
    // Tạo lịch đặt
    createBooking: async (req, res) => {
        try {
            const { thoi_gian_bat_dau, thoi_gian_ket_thuc, bds_id } = req.body;
            const nguoi_dung_id = req.user.id; // Get from Token

            const newBooking = await Booking.create({
                thoi_gian_bat_dau,
                thoi_gian_ket_thuc,
                bds_id,
                nguoi_dung_id,
                trang_thai: 'cho_duyet'
            });

            res.status(201).json({ message: "Đặt lịch thành công!", booking: newBooking });
        } catch (error) {
            console.error("Booking Error:", error);
            res.status(500).json({ message: "Lỗi đặt lịch: " + error.message, error: error.message });
        }
    },

    // Lấy danh sách đặt lịch của người dùng (Tenant)
    getUserBookings: async (req, res) => {
        try {
            const { userId } = req.params;
            const bookings = await Booking.findAll({
                where: { nguoi_dung_id: userId },
                include: [{ model: Property, attributes: ['ten_bds', 'dia_chi', 'gia_thue', 'images'] }],
                order: [['createdAt', 'DESC']]
            });
            res.json(bookings);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy danh sách đặt lịch", error: error.message });
        }
    },

    // Lấy danh sách yêu cầu đặt lịch cho chủ nhà (Host)
    getHostBookings: async (req, res) => {
        try {
            const userId = req.user.id; // From middleware

            // 1. Find all properties owned by this host
            const properties = await Property.findAll({
                where: { nguoi_dung_id: userId },
                attributes: ['bds_id']
            });

            const propertyIds = properties.map(p => p.bds_id);

            if (propertyIds.length === 0) {
                return res.json([]);
            }

            // 2. Find bookings for these properties
            const bookings = await Booking.findAll({
                where: { bds_id: propertyIds },
                include: [
                    { model: Property, attributes: ['ten_bds', 'gia_thue'] },
                    { model: User, attributes: ['ho_ten', 'so_dien_thoai', 'email'] } // Info of tenant
                ],
                order: [['createdAt', 'DESC']]
            });

            res.json(bookings);
        } catch (error) {
            console.error("getHostBookings Error:", error);
            res.status(500).json({ message: "Lỗi lấy danh sách yêu cầu", error: error.message });
        }
    },

    // Cập nhật trạng thái (Duyệt/Hủy)
    updateStatus: async (req, res) => {
        try {
            const { id } = req.params;
            const { trang_thai } = req.body; // 'confirmed', 'cancelled', 'completed'

            await Booking.update({ trang_thai }, { where: { dat_lich_id: id } });
            res.json({ message: "Cập nhật trạng thái thành công" });
        } catch (error) {
            res.status(500).json({ message: "Lỗi cập nhật trạng thái", error: error.message });
        }
    }
};

module.exports = BookingController;
