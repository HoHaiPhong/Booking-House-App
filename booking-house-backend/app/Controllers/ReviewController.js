const { Review, User } = require('../Models');

const ReviewController = {
    addReview: async (req, res) => {
        try {
            const { so_sao, noi_dung, bds_id, nguoi_dung_id } = req.body;

            const newReview = await Review.create({
                so_sao, noi_dung, bds_id, nguoi_dung_id
            });

            res.status(201).json({ message: "Đánh giá thành công!", review: newReview });
        } catch (error) {
            res.status(500).json({ message: "Lỗi thêm đánh giá", error: error.message });
        }
    },

    getReviewsByProperty: async (req, res) => {
        try {
            const { propertyId } = req.params;
            const reviews = await Review.findAll({
                where: { bds_id: propertyId },
                include: [{ model: User, attributes: ['ho_ten'] }]
            });
            res.json(reviews);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy đánh giá", error: error.message });
        }
    }
};

module.exports = ReviewController;
