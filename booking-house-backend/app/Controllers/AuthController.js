const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { User } = require('../Models');


const AuthController = {
    // Đăng ký người dùng mới
    register: async (req, res) => {
        try {
            const { ho_ten, email, mat_khau, so_dien_thoai, role_id } = req.body;

            // Mã hóa mật khẩu
            const salt = await bcrypt.genSalt(10);
            const hashedPw = await bcrypt.hash(mat_khau, salt);

            const newUser = await User.create({
                ho_ten, email, so_dien_thoai, role_id,
                mat_khau: hashedPw
            });

            res.status(201).json({ message: "Đăng ký thành công", userId: newUser.nguoi_dung_id });
        } catch (error) {
            res.status(500).json({ message: "Lỗi đăng ký", error: error.message });
        }
    },

    // Đăng nhập
    login: async (req, res) => {
        try {
            const { email, mat_khau } = req.body;
            const user = await User.findOne({ where: { email } });

            if (!user) return res.status(404).json({ message: "Email không tồn tại" });

            const isMatch = await bcrypt.compare(mat_khau, user.mat_khau);
            if (!isMatch) return res.status(400).json({ message: "Mật khẩu sai" });

            // Tạo JWT Token để Android App lưu lại
            const token = jwt.sign(
                { id: user.nguoi_dung_id, role: user.role_id },
                process.env.JWT_SECRET,
                { expiresIn: '7d' }
            );

            res.json({ token, user: { id: user.nguoi_dung_id, ho_ten: user.ho_ten } });
        } catch (error) {
            res.status(500).json({ message: "Lỗi đăng nhập" });
        }
    }
};

module.exports = AuthController;