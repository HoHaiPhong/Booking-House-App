const { Category } = require('../Models');

const CategoryController = {
    getAllCategories: async (req, res) => {
        try {
            const categories = await Category.findAll();
            res.json(categories);
        } catch (error) {
            res.status(500).json({ message: "Lỗi lấy danh mục", error: error.message });
        }
    }
};

module.exports = CategoryController;
