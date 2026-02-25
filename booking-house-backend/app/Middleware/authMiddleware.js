const jwt = require('jsonwebtoken');
require('dotenv').config();

const authMiddleware = {
    // 1. Verify Token (Authentication)
    verifyToken: (req, res, next) => {
        const token = req.headers['authorization'];

        if (!token) {
            return res.status(403).json({ message: "No token provided!" });
        }

        // Bearer <token>
        const bearer = token.split(' ');
        const bearerToken = bearer[1];

        jwt.verify(bearerToken, process.env.JWT_SECRET, (err, decoded) => {
            if (err) {
                return res.status(401).json({ message: "Unauthorized!" });
            }
            req.user = decoded; // { id, role }
            next();
        });
    },

    // 2. Check Admin Role (Authorization)
    isAdmin: (req, res, next) => {
        if (req.user && req.user.role === 1) { // 1 = Admin as per seed
            next();
        } else {
            res.status(403).json({ message: "Require Admin Role!" });
        }
    },

    // 3. Check Host Role (Host or Admin can post properties)
    // 3. Check User or Admin Role (Both can manage properties, though logic limits scope)
    isUserOrAdmin: (req, res, next) => {
        // Role 2 = User (Post/Rent), Role 1 = Admin.
        if (req.user && (req.user.role === 2 || req.user.role === 1)) {
            next();
        } else {
            res.status(403).json({ message: "Require User or Admin Role!" });
        }
    }
};

module.exports = authMiddleware;
