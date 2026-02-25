const { Message, User } = require('../Models');
const { Op } = require('sequelize');

const ChatController = {
    // Lấy tin nhắn giữa 2 người
    getMessages: async (req, res) => {
        try {
            const { userId1, userId2 } = req.params;

            const messages = await Message.findAll({
                where: {
                    [Op.or]: [
                        { gui_tu_id: userId1, gui_den_id: userId2 },
                        { gui_tu_id: userId2, gui_den_id: userId1 }
                    ]
                },
                order: [['thoi_gian_gui', 'ASC']]
            });

            res.json(messages);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy tin nhắn", error: error.message });
        }
    },

    // Lấy danh sách những người đã chat với user (Recent chats)
    getConversations: async (req, res) => {
        try {
            const { userId } = req.params;
            // Logic này phức tạp hơn 1 chút, có thể dùng DISTINCT ON hoặc GROUP BY trong SQL thuần
            // Tạm thời lấy tất cả rồi lọc ở code JS cho đơn giản nếu list ít
            // Hoặc dùng query raw cho tối ưu
            const query = `
                SELECT DISTINCT ON (LEAST(gui_tu_id, gui_den_id), GREATEST(gui_tu_id, gui_den_id))
                    tin_nhan_id, gui_tu_id, gui_den_id, noi_dung, thoi_gian_gui
                FROM tin_nhan
                WHERE gui_tu_id = :userId OR gui_den_id = :userId
                ORDER BY LEAST(gui_tu_id, gui_den_id), GREATEST(gui_tu_id, gui_den_id), thoi_gian_gui DESC
            `;
            // Cần import sequelize instance để chạy raw query nếu cần. 
            // Tuy nhiên để an toàn và nhanh, ta chỉ implement getMessages trước.
            // getConversations có thể làm sau hoặc dùng logic đơn giản hơn.

            res.json({ message: "Tính năng đang cập nhật" });
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy danh sách chat" });
        }
    }
};

module.exports = ChatController;
